FROM quay.io/pypa/manylinux2014_x86_64:2022-11-28-5d13db4

ENV PYTHON /usr/local/bin/python3.7
# fix include directories
RUN for d in /opt/_internal/cpython-3.7.* ; do echo ${d} ; ln -sf ${d}/include/python3.7m ${d}/include/python3.7 ; done

RUN yum -y install centos-release-scl \
 && yum-config-manager --enable rhel-server-rhscl-7-rpms \
 && yum -y install rh-git218
RUN ln -s /opt/rh/rh-git218/root/usr/bin/git /usr/bin/git \
 && ln -s /opt/rh/httpd24/root/usr/lib64/libcurl-httpd24.so.4.5.0      /usr/lib64/libcurl-httpd24.so.4 \
 && ln -s /opt/rh/httpd24/root/usr/lib64/libnghttp2-httpd24.so.14.4.1  /usr/lib64/libnghttp2-httpd24.so.14
RUN yum -y install chrpath cmake fftw-devel hdf5-devel hdf5-static libtool devtoolset-11
RUN $PYTHON -m pip install auditwheel dynesty h5py matplotlib 'numpy>=1.13.3,<2' scipy twine pypmc pyyaml wheel wilson

# copy system pkg.m4 to manylinux2014's custom aclocal installation in /usr/local
RUN cp /usr/share/aclocal/pkg.m4 /usr/local/share/aclocal/pkg.m4

# remove system yaml and install v0.6.2
# installation destination of the pkg-config file is hardcoded to /usr/lib/pkgconfig
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
 && rm -Rf yaml \
 && mv /usr/lib/pkgconfig/yaml-cpp.pc /usr/lib64/pkgconfig/yaml-cpp.pc

# install boost
RUN mkdir /boost \
 && pushd /boost \
 && curl -L -O https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz \
 && tar zxf /boost/boost_1_76_0.tar.gz \
 && pushd boost_1_76_0 \
 && ./bootstrap.sh --with-python=$PYTHON --with-libraries=filesystem,python,system \
 && ./b2 install --build-type=minimal --prefix=/usr

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

RUN ldconfig
