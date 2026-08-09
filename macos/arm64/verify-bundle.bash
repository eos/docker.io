set -eo pipefail
set -x

# End-to-end gate: run against the extracted contents of the tarball that is about to
# be pushed (not the raw $DESTDIR staging tree), so a packaging mistake is caught too,
# not just a build-script one. Usage: verify-bundle.bash <extracted-tarball-root>
CHECKDIR="$1"
LIBDIR="${CHECKDIR}${PREFIX}/lib"
BINDIR="${CHECKDIR}${PREFIX}/bin"

status=0

fail() {
    echo "error: $1" >&2
    status=1
}

# Every real (non-symlink) dylib must have an absolute ${PREFIX}/lib/<name> install
# name, every non-system dependency must likewise be an absolute ${PREFIX}/lib/...
# path (no bare names, no @rpath/@loader_path/@executable_path), no LC_RPATH may be
# present at all (the bundle is meant to be self-describing via absolute paths, not
# via rpath resolution), no load command may mention the DESTDIR staging path, and the
# ad-hoc signature install_name_tool's rewriting invalidated must have been restored.
for dylib in "${LIBDIR}"/*.dylib ; do
    [ -L "${dylib}" ] && continue
    name=$(basename "${dylib}")

    id=$(otool -D "${dylib}" | tail -n +2)
    if [ "${id}" != "${PREFIX}/lib/${name}" ] ; then
        fail "${dylib}: install name is '${id}', expected '${PREFIX}/lib/${name}'"
    fi

    # `otool -L`'s first entry after the header is always the file's own LC_ID_DYLIB
    # (already checked above, and reported precisely there) -- skip a further line
    # with `tail -n +3` so a broken id isn't also reported a second time here as a
    # generic "dependency" failure.
    while read -r dep ; do
        case "${dep}" in
            /usr/lib/*|/System/*|"${PREFIX}"/lib/*)
                continue
                ;;
        esac
        fail "${dylib}: dependency '${dep}' is not an absolute ${PREFIX}/lib path"
    done < <(otool -L "${dylib}" | tail -n +3 | awk '{print $1}')

    if otool -l "${dylib}" | grep -q "cmd LC_RPATH" ; then
        fail "${dylib}: carries an LC_RPATH -- the bundle must resolve via absolute paths only"
    fi

    # `otool -D`/`-L` echo the path they were given as their first line, which is
    # itself under $CHECKDIR here -- skip it with `tail -n +2` so this only inspects
    # the actual load-command values, not the argument echoed back.
    if otool -D "${dylib}" | tail -n +2 | grep -q "${DESTDIR}" || otool -L "${dylib}" | tail -n +2 | grep -q "${DESTDIR}" ; then
        fail "${dylib}: references the DESTDIR staging path (${DESTDIR})"
    fi

    if ! codesign --verify --strict "${dylib}" ; then
        fail "${dylib}: does not carry a valid code signature"
    fi
done

# The bundle also ships a handful of Mach-O executables (gsl-histogram, gsl-randist,
# fftw-wisdom); they carry no LC_ID_DYLIB but the same dependency/DESTDIR/signature
# invariants apply, and a future dependency bump could break them just as easily.
for exe in "${BINDIR}"/* ; do
    [ -L "${exe}" ] && continue
    file "${exe}" | grep -q "Mach-O" || continue

    while read -r dep ; do
        case "${dep}" in
            /usr/lib/*|/System/*|"${PREFIX}"/lib/*)
                continue
                ;;
        esac
        fail "${exe}: dependency '${dep}' is not an absolute ${PREFIX}/lib path"
    done < <(otool -L "${exe}" | tail -n +2 | awk '{print $1}')

    if otool -L "${exe}" | tail -n +2 | grep -q "${DESTDIR}" ; then
        fail "${exe}: references the DESTDIR staging path (${DESTDIR})"
    fi

    if ! codesign --verify --strict "${exe}" ; then
        fail "${exe}: does not carry a valid code signature"
    fi
done

exit "${status}"
