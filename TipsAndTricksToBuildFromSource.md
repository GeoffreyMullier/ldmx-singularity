# Building from source

_This section is about building tricks to build from source, bare metal on Centos, though most of the findings can be also adapted to other systems_

**This file is a work in progress and hopefully will grow more complete as things advance.**

## General Comments

* **-jX option** should be normally number of cores +1 or +2, the reason for this is -j signifies jobs or threads, most of the threads would be per core, but some resulting actions will have disk I/O which is slow, so a thread or two more than the number of cores can improve compilation speed, NB, setting this number too high actually slows down compilation, basically you put too many jobs in the pipeline for the CPUs to process it.

---

## GCC

Not done yet, but at any rate should be done before everything else if ever attempted (the rest hinges on gcc)

---

## Python

For building python and getting all dependencies right I followed some recipes that can be found below

https://stackoverflow.com/questions/49763362/cant-build-optional-modules-readline-and-curses-when-compiling-python3-4-from
https://docs.rstudio.com/resources/install-python-source/

In addition in the script I basically set that python not in the original location that the system would see but in /opt/pythonX (where X is the version)

The reason for this was to avoid having problems with system version of python, this is not an issue for python2 where you install python3 this might be an issue with python3 pre installed and if you try to get another version of python3 I havent tested yet

In this particular case the bootstrap would find the gcc version given by devtoolset since the environment links everything to the "right" version of gcc. 
I am suspecting that in a case where there is an alternate version of gcc one might need to specify which one would be the usual suspect, I haven't looked into it but that should come in a bit

N.B. The method I use currently to add the python3 executable and libraries to the global environment PATH and LD_PATH sort of assumes that python3 is not installed on the system, there might be therefore a mismatch between those executables if there is already a system-wide install of python3, one could use the system-wide dev version, but I like it from source.

The commands in raw on CentOS would be something along the lines of
```bash
   export PYTHON_VER=3.8.0
   wget --no-check-certificate https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz
   tar -xzvf Python-${PYTHON_VER}.tgz
   #Dirty way of getting the base version and sub-version of python
   PYTHON_VER_SHORT=${PYTHON_VER:0:3};
   PYTHON_VER_SHORTER=${PYTHON_VER:0:1};
   PYTHON_DIR=/opt/python${PYTHON_VER_SHORT}

   cd Python-${PYTHON_VER}/
   ./configure --prefix=/opt/python${PYTHON_VER_SHORT} --enable-optimizations --with-ensurepip=install --with-cxx-main=gcc --enable-shared
   make -j8 && make install
   
   export PATH=${PYTHON_DIR}/bin:$PATH
   export LD_LIBRARY_PATH=${PYTHON_DIR}/lib:$LD_LIBRARY_PATH
```

---

## Boost

Building boost from source can be headache inducing, especially because in theory the boost developers wants you to modify the `user-config.jam` in order to compile 

This being said, in the definition script, I list a method that was found by someone to define the required parameters

This was found out with those resources

https://mail.python.org/pipermail/cplusplus-sig/2016-July/017411.html

I haven't tried yet to make multi threading and MPI powered ones there is some information on how to activate it there
http://www.linuxfromscratch.org/blfs/view/svn/general/boost.html


```bash
  export BOOST_VER=1.73.0
  wget https://dl.bintray.com/boostorg/release/${BOOST_VER}/source/boost_${BOOST_VER//[.]/_}.tar.bz2
  tar -jxvf boost_${BOOST_VER//[.]/_}.tar.bz2
  export BOOST_DIR=/opt/boost-${BOOST_VER//[.]/_}
  cd boost_${BOOST_VER//[.]/_}
  ./bootstrap.sh --prefix=$BOOST_DIR --with-python=${PYTHON_DIR}/bin/python${PYTHON_VER_SHORTER} --with-python-version=${PYTHON_VER_SHORT} --with-python-root=${PYTHON_DIR}
  ./b2 -j8 --enable-unicode=ucs4 install --prefix=$BOOST_DIR --with=all
```
---

## CMake

Normally the script is working quite OK for this, there are some subtleties requiering you to use a more recent version of cmake in order to make the whole thing work.

There was a bug in previous version of FindPythonInterpreter module of cmake, causing it to detect the wrong version of the python interpreter, it would see python interpreter 1.4 instead of whatever version you would have if you were using an externally compiled version of python with respect to the system one

---

## Xerces

```bash
  export XERCES_VER=3.2.3
  XERCES_VER_SHORT=${XERCES_VER:0:1}
  wget http://archive.apache.org/dist/xerces/c/${XERCES_VER_SHORT}/sources/xerces-c-${XERCES_VER}.tar.bz2
  tar -jxvf xerces-c-${XERCES_VER}.tar.bz2
  export XERCESC_DIR=/opt/xerces-c-$XERCES_VER
  cd xerces-c-${XERCES_VER}
  ./configure --prefix=$XERCESC_DIR
  make -j8 && make install
```
---

## Geant4

Normally if the other dependencies are building normally this should build alright with the options passed to cmake

---

## ROOT

Normally if the other dependencies are building fine this one shouldn't be an issue, the only thing to consider is if it's build with Python3 to set the options right, in this case one should be careful about their python libraries, includes and executables
```bash
  export ROOTVERSION=6.20.04
  PYCMAKEFLAGS="-Dpython3=ON -DPYTHON_EXECUTABLE=${PYTHON_DIR}/bin/python${PYTHON_VER_SHORTER} -DPYTHON_INCLUDE_DIR=${PYTHON_DIR}/include/python${PYTHON_VER_SHORT}/ -DPYTHON_LIBRARY=${PYTHON_DIR}/lib/libpython3.so"
  yum -y install libXpm-devel libXft-devel libXext-devel gsl-devel fftw-devel blas-devel
  wget https://root.cern.ch/download/root_v$ROOTVERSION.source.tar.gz
  tar -zxvf root_v$ROOTVERSION.source.tar.gz
  mkdir root-cmake-build
  cd root-cmake-build
  export ROOTDIR=/opt/root-$ROOTVERSION
  cmake -Dgdml=ON -Dexplicitlink=ON ${PYCMAKEFLAGS} -DCMAKE_INSTALL_PREFIX=$ROOTDIR -Dcxx17=ON ../root-$ROOTVERSION
  make -j8 && make install
