set -x

mkdir -p /tmp/boost
pushd /tmp/boost


echo Download the tarball
curl -L -O https://boostorg.jfrog.io/artifactory/main/release/1.85.0/source/boost_1_85_0.tar.gz

echo Untar
tar zxf boost_1_85_0.tar.gz

echo Build Boost
pushd boost_1_85_0
gsed -i -e '/^#include <boost\/phoenix\/stl\/tuple\.hpp/d' boost/phoenix/stl.hpp
echo "Build Boost (Python-independent parts)"
./bootstrap.sh --prefix=$PREFIX --with-libraries=filesystem,math,system
./b2 install link=shared threading=single --prefix=${DESTDIR}/${PREFIX} -j ${JOBS}
for pyver in ${PYTHON_VERSIONS} ; do
    echo "Build Boost (libboost_python${pyver/./})" 
    pyinc=${PREFIX}/opt/python@${pyver}/Frameworks/Python.framework/Versions/${pyver}/include/python${pyver}/
    pylib=${PREFIX}/opt/python@${pyver}/Frameworks/Python.framework/Versions/${pyver}/lib
    export PYTHON=${PREFIX}/bin/python${pyver}
    cat > user-config.jam <<EOF
        using darwin : : clang++ ;
        using python : ${pyver}
                     : ${PYTHON}
                     : ${pyinc}
                     : ${pylib} ;
EOF
    gsed -i -e 's/using python/#using python/' ./bootstrap.sh
    ./bootstrap.sh --with-python=$PYTHON --with-python-root=${PREFIX} --with-libraries=python
    ./b2 install \
        link=shared threading=single \
        cxxflags=-std=c++14 \
        cxxflags=-stdlib=libc++ \
        linkflags=-stdlib=libc++ \
        --user-config=user-config.jam \
        --prefix=${DESTDIR}/${PREFIX} \
        -j ${JOBS}
done
popd
popd