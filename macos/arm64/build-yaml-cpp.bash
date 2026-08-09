set -eo pipefail
set -x

mkdir -p /tmp/yaml/build
pushd /tmp/yaml

echo Download the tarball
curl -L -O https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.9.0.tar.gz

echo Untar
tar zxf yaml-cpp-0.9.0.tar.gz

echo Build yaml-cpp
pushd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX -DBUILD_SHARED_LIBS=on -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ../yaml-cpp-yaml-cpp-0.9.0
make -j${JOBS}
make install DESTDIR=$DESTDIR
popd
popd
