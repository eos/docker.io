set -eo pipefail
set -x

mkdir -p /tmp/fftw
pushd /tmp/fftw

echo Download the tarball
curl -L -O https://www.fftw.org/fftw-3.3.10.tar.gz

echo Untar
tar zxf fftw-3.3.10.tar.gz

pushd fftw-3.3.10
echo Build FFTW3
./configure --prefix=$PREFIX --enable-shared
make -j${JOBS}
make install DESTDIR=$DESTDIR
popd
popd
