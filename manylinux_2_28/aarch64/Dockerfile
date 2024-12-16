FROM quay.io/pypa/manylinux_2_28_aarch64:2023-10-22-409125c

RUN yum -y install chrpath cmake git libtool \
  && yum -y clean all \
  && rm -rf /var/cache/yum

# installation destination of the pkg-config file is hardcoded to /usr/lib/pkgconfig
RUN mkdir -p /yaml/build \
 && pushd /yaml \
 && curl -L -O https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz \
 && tar zxf 0.8.0.tar.gz \
 && pushd build \
 && export CXXFLAGS="-O2 -g -fPIC -DPIC" \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DBUILD_SHARED_LIBS=on ../yaml-cpp-0.8.0 \
 && make -j4 \
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

# python version-dependent part

ARG PYTHON_VERSIONS="3.10"

# install boost
#  - fix bug when linking against boost/phoenix
RUN mkdir /boost \
 && pushd /boost \
 && curl -L -O https://boostorg.jfrog.io/artifactory/main/release/1.83.0/source/boost_1_83_0.tar.gz \
 && tar zxf /boost/boost_1_83_0.tar.gz \
 && pushd boost_1_83_0 \
 && sed -i -e '/^#include <boost\/phoenix\/stl\/tuple\.hpp/d' boost/phoenix/stl.hpp \
 && ./bootstrap.sh --with-python=$PYTHON --with-libraries=filesystem,system \
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
      $PYTHON -m pip install argcomplete auditwheel 'dynesty==2.0.3' matplotlib 'numpy>=2' scipy termcolor twine pyhf pypmc pyyaml wheel wilson ; \
    done

# make pkg.m4 available to aclocal
RUN cp /usr/share/aclocal/pkg.m4 /usr/local/share/aclocal/pkg.m4
