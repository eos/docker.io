FROM quay.io/pypa/manylinux_2_34_x86_64:2026.04.04-1

RUN yum -y install chrpath cmake git gsl gsl-devel libtool

# installation destination of the pkg-config file is hardcoded to /usr/lib/pkgconfig
#  - using -DCMAKE_POLICY_VERSION_MINIMUM=3.5 to avoid https://github.com/jbeder/yaml-cpp/issues/1352
RUN mkdir -p /yaml/build \
 && pushd /yaml \
 && curl -L -O https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.9.0.tar.gz \
 && tar zxf yaml-cpp-0.9.0.tar.gz \
 && pushd build \
 && export CXXFLAGS="-O2 -g -march=x86-64 -fPIC -DPIC" \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DBUILD_SHARED_LIBS=on -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ../yaml-cpp-yaml-cpp-0.9.0 \
 && make -j2 \
 && make install \
 && popd \
 && popd \
 && rm -Rf yaml

# install GSL
RUN mkdir /gsl \
 && pushd /gsl \
 && curl -L -O https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz \
 && tar zxf /gsl/gsl-2.7.tar.gz \
 && pushd gsl-2.7 \
 && ./configure --prefix=/usr \
 && make -j4 \
 && make install \
 && popd \
 && popd \
 && rm -Rf gsl

# install FFTW3
RUN mkdir /fftw \
 && pushd /fftw \
 && curl -L -O https://www.fftw.org/fftw-3.3.10.tar.gz \
 && tar zxf /fftw/fftw-3.3.10.tar.gz \
 && pushd fftw-3.3.10 \
 && ./configure --prefix=/usr --enable-shared \
 && make -j4 \
 && make install \
 && popd \
 && popd \
 && rm -Rf fftw

# python version-dependent part

ARG PYTHON_VERSIONS="3.10 3.11 3.12 3.13 3.14"

# install boost
#  - fix bug when linking against boost/phoenix
RUN mkdir /boost \
 && pushd /boost \
 && curl -L -O https://archives.boost.io/release/1.90.0/source/boost_1_90_0.tar.gz \
 && tar zxf /boost/boost_1_90_0.tar.gz \
 && pushd boost_1_90_0 \
 && sed -i -e '/^#include <boost\/phoenix\/stl\/tuple\.hpp/d' boost/phoenix/stl.hpp \
 && ./bootstrap.sh --with-python=$PYTHON --with-libraries=filesystem,math,system \
 && ./b2 install --build-type=minimal --prefix=/usr \
 && for pyver in ${PYTHON_VERSIONS} ; do \
      export PYTHON=/usr/local/bin/python${pyver} ; \
      ./bootstrap.sh --with-python=$PYTHON --with-libraries=python ; \
      ./b2 install --build-type=minimal --prefix=/usr ; \
    done \
 && popd \
 && popd \
 && rm -Rf /boost

RUN ldconfig

RUN for pyver in ${PYTHON_VERSIONS} ; do \
      export PYTHON=/usr/local/bin/python${pyver} ; \
      $PYTHON -m pip install argcomplete auditwheel dynesty matplotlib 'numpy>=2' scipy termcolor twine pyhf 'pypmc>=1.2.6' pyyaml wheel wilson ; \
    done

# make pkg.m4 available to aclocal
RUN cp /usr/share/aclocal/pkg.m4 /usr/local/share/aclocal/pkg.m4
