FROM quay.io/pypa/manylinux2014_x86_64:latest

ENV PYTHON /usr/local/bin/python3.10

RUN yum -y install centos-release-scl \
 && yum-config-manager --enable rhel-server-rhscl-7-rpms \
 && yum -y install rh-git218
RUN ln -s /opt/rh/rh-git218/root/usr/bin/git /usr/bin/git \
 && ln -s /opt/rh/httpd24/root/usr/lib64/libcurl-httpd24.so.4.5.0      /usr/lib64/libcurl-httpd24.so.4 \
 && ln -s /opt/rh/httpd24/root/usr/lib64/libnghttp2-httpd24.so.14.4.1  /usr/lib64/libnghttp2-httpd24.so.14
RUN yum -y install chrpath cmake fftw-devel gsl gsl-devel hdf5-devel hdf5-static libtool
RUN $PYTHON -m pip install auditwheel h5py matplotlib 'numpy>=1.13.3,<2' scipy twine pypmc pyyaml wheel wilson

# remove system yaml and install v0.6.2
RUN yum -y erase yaml-cpp
RUN mkdir -p /yaml/build \
 && pushd /yaml \
 && curl -L -O https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.tar.gz \
 && tar zxf yaml-cpp-0.6.2.tar.gz \
 && pushd build \
 && export CXXFLAGS="-O2 -g -march=x86-64 -fPIC -DPIC" \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DBUILD_SHARED_LIBS=on ../yaml-cpp-yaml-cpp-0.6.2 \
 && make -j4 \
 && make install \
 && popd \
 && popd \
 && rm -Rf yaml

# install boost
RUN mkdir /boost \
 && pushd /boost \
 && curl -L -O https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz \
 && tar zxf /boost/boost_1_76_0.tar.gz \
 && pushd boost_1_76_0 \
 && ./bootstrap.sh --with-python=$PYTHON --with-libraries=filesystem,python,system \
 && ./b2 install --build-type=minimal --prefix=/usr

# install gcc-10
RUN yum -y install epel-release \
 && yum -y --nogpg install https://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm \
 && yum -y install gcc10-gcc-c++

RUN ldconfig
