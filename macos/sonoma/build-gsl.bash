set -x

mkdir -p /tmp/gsl/build
pushd /tmp/gsl

echo Download the tarball
curl -L -O https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz

echo Untar
tar zxf gsl-2.7.tar.gz

pushd build
echo Build GSL
../gsl-2.7/configure --prefix=$PREFIX LDFLAGS="-Wl,-not_for_dyld_shared_cache"
make -j${JOBS} 
make install DESTDIR=$DESTDIR
popd
popd