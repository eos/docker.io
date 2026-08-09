set -eo pipefail
set -x

LIBDIR="${DESTDIR}${PREFIX}/lib"

# b2 install (Boost) does not implement DESTDIR the way autotools/CMake do: it leaves
# libboost_*.dylib with a bare LC_ID_DYLIB (or, for libboost_filesystem and the like,
# an @rpath one) and bare/@rpath intra-bundle LC_LOAD_DYLIB references, with no
# LC_RPATH anywhere to resolve them. GSL/yaml-cpp/FFTW3 got their own install name
# right, but not necessarily every reference to a sibling library, so the same loop
# below is applied to every dylib in the bundle rather than special-cased to Boost.
for dylib in "${LIBDIR}"/*.dylib ; do
    # The various libfoo.dylib -> libfoo.N.dylib symlinks carry no load commands of
    # their own and need no rewriting.
    [ -L "${dylib}" ] && continue

    name=$(basename "${dylib}")

    # The install name is what every future consumer (including the eos build itself)
    # embeds as its own dependency reference, so it must always be the final absolute
    # path -- regardless of whether it is currently bare, @rpath-based, or (were it to
    # happen) DESTDIR-prefixed.
    install_name_tool -id "${PREFIX}/lib/${name}" "${dylib}"

    # Rewrite every dependency on another dylib shipped in this same bundle -- bare,
    # @rpath/-based, or DESTDIR-prefixed -- to its final absolute path. System
    # libraries (/usr/lib/..., /System/...) are left untouched.
    otool -L "${dylib}" | tail -n +2 | awk '{print $1}' | while read -r dep ; do
        case "${dep}" in
            /usr/lib/*|/System/*)
                continue
                ;;
        esac
        depname=$(basename "${dep}")
        if [ -e "${LIBDIR}/${depname}" ] && [ "${dep}" != "${PREFIX}/lib/${depname}" ] ; then
            install_name_tool -change "${dep}" "${PREFIX}/lib/${depname}" "${dylib}"
        fi
    done

    # install_name_tool invalidates the code signature, and arm64 macOS refuses to
    # load an unsigned (or invalidated) Mach-O. Do not rely on install_name_tool's
    # occasional automatic ad-hoc re-signing -- do it explicitly.
    codesign --force --sign - "${dylib}"

    # Fail here, immediately, rather than waiting for the end-to-end verification
    # step to notice a rewrite that didn't stick. `otool -L` always echoes the path
    # it was given as its first line, and that path is itself inside $DESTDIR at
    # this point in the build -- skip it with `tail -n +2`, or this check would
    # fail on every single file regardless of what its load commands actually say.
    if otool -L "${dylib}" | tail -n +2 | grep -q "${DESTDIR}" ; then
        echo "error: ${dylib} still references DESTDIR (${DESTDIR}) after normalisation" >&2
        exit 1
    fi
done
