set -x

mkdir -p /tmp/yaml/build
pushd /tmp/yaml

echo Download the tarball
curl -L -O https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz

echo Untar
tar zxf 0.8.0.tar.gz

echo Build yaml-cpp
pushd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX -DBUILD_SHARED_LIBS=on ../yaml-cpp-0.8.0
make -j${JOBS}
make install DESTDIR=$DESTDIR
popd
popd