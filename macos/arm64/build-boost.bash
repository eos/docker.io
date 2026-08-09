set -eo pipefail
set -x

mkdir -p /tmp/boost
pushd /tmp/boost


echo Download the tarball
curl -L -O https://archives.boost.io/release/1.90.0/source/boost_1_90_0.tar.gz

echo Untar
tar zxf boost_1_90_0.tar.gz

echo Build Boost
pushd boost_1_90_0
gsed -i -e '/^#include <boost\/phoenix\/stl\/tuple\.hpp/d' boost/phoenix/stl.hpp
echo "Build Boost (Python-independent parts)"
./bootstrap.sh --prefix=$PREFIX --with-libraries=filesystem,math,system
./b2 install link=shared threading=single cxxflags="${CXXFLAGS}" --prefix=${DESTDIR}/${PREFIX} -j ${JOBS}
for pyver in ${PYTHON_VERSIONS} ; do
    echo "Build Boost (libboost_python${pyver/./})"
    # Use the runner's own CPython (installed by actions/setup-python from its
    # pre-cached tool versions), not a Homebrew-installed Python: it is already
    # present, so building/fetching one via Homebrew is pure waste. Query the
    # interpreter itself for its layout instead of assuming a particular
    # installation's directory structure (Homebrew's framework layout differs
    # from the toolcache's).
    export PYTHON=$(command -v python${pyver})
    pyinc=$(${PYTHON} -c "import sysconfig; print(sysconfig.get_paths()['include'])")
    pylib=$(${PYTHON} -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))")
    cat > user-config.jam <<EOF
        using darwin : : clang++ ;
        using python : ${pyver}
                     : ${PYTHON}
                     : ${pyinc}
                     : ${pylib} ;
EOF
    gsed -i -e 's/using python/#using python/' ./bootstrap.sh
    ./bootstrap.sh --with-python=$PYTHON --with-libraries=python
    ./b2 install \
        link=shared threading=single \
        cxxflags=-std=c++14 \
        cxxflags=-stdlib=libc++ \
        cxxflags="${CXXFLAGS}" \
        linkflags=-stdlib=libc++ \
        --user-config=user-config.jam \
        --prefix=${DESTDIR}/${PREFIX} \
        -j ${JOBS}
done
popd
popd
