# Getting started

1. Get the sources
The patched Geant4 sources and LDMX software sources should be obtained from GIT. Build scripts look
for sources in the `src/` directory:
`cd src/`
`./checkout.sh`

1. Define versions
In the `ldmx.buildvers` file you can define a different versions of LDMX and dependencies that are used.
Following is a description of the available options:
   * BOOST_VER=1.73.0 - Defines the boost version, currently it is broken and the build process doesn't work
   
   * PYTHON_VER=3.8.0 - Defines Python version, downloads the correct version and compiles with shared libraries (currently not fully tested since needs a compiled from source python version to compile boost)

   * ONNX_VER=1.3.0 - Defines version of ONNX libraries, download the binaries without compiling them
   
   * ONNX_GPU=OFF - ON/OFF, Defines if the version of ONNX should be a GPU one (the ones available offer CUDA support) to run with the container need to use the -nv experimental option for CUDA support
   
   * CENTOS=7 - defines the CentOS version. Please note that at the time of writing only CentOS 7
builds are fully tested.

   * DEVTOOLSET=7 - defines the devloolset version to install. The value ‘S’ means system compilers
usage without installing particular devtoolset pack. If you are not familiar with CetnOS devtools sets,
you can interpret the number as GCC major version. 6, 7 and 8 are those you can try.

   * CMAKE_VER=3.13.5 - version of CMake. According to our experience the LDMX software and
dependencies are very sensitive to CMake version. Do not change it if you do not have real
reasons.

   * XERCES_VER=3.2.3 - version of Xerces-C. The latest and recommended is 3.2.3.

   * ROOTVERSION=6.20.04 - version of Root to build.

   * GEANT4_TAG=LDMX.10.2.3_v0.3 - Tag of LDMX-forked Geant4 source tree to build

   * LDMX_TAG=v2.0.0 - Tag of LDMX software to build, using latest gets the latest master 

   * MAKEOPTS=-j8 - Additional options to pass to make command. Using -j&lt;number of cores&gt; is
recommended to speed-up build process.

   * MARCH=sandybridge - Optionally define instructions set optimization for the machine CPU type (e.g
-march= CFLAG). It can improve performance but limit the portability. If not defined, general release
compiler flags will be used.

## Building a dev version (Currently not working)

Run build process `build-dev.sh` script will start the build process.
This will generate a Sandbox singularity image with all dependencies build 

Change the ownership of the container to be the current user by `chown -R $(id -u):$(id -g) ldmx-dev-test` if transfered to another machine some part of the system from the centos machine won't be transfered but the hability to build from inside the container will be preserved.

In order to run the sandbox use 

`singularity shell -w ldmx-dev-test`

To be completed...

## Building a prod version (Supposedly currently working for V2.0.0, though has still non prod things in there)

The `build-prod.sh` script will start the build process. First, it will generate intermediate singularity image with all dependencies build (except LDMX software itself). In case intermediate build image is already present in the working directory it will not be rebuilt again next time. This allows to update LDMX software with the same dependencies with much less efforts. The next step is to build the LDMX software and produce the “release” image that only contains runtime dependencies without build leftovers (like sources and build files). This release image should be used to run simulations.

4. Using LDMX release image
The LDMX singularity image already defines necessary environment variables for LDMX software and dependencies. So you can just run ldmx-sim or ldmx-app without any extra steps. The “run” command runs fire, so 
`singularity run ldmx.sif run.py`
or
`./ldmx.sif run.py`
is equivalent to
`singularity exec ldmx.sif fire run.py`

The image doesn’t include self-test functionality right now, that runs simple simulation with singularity (needs to be added)
