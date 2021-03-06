# Getting started

1. Get the sources
The patched Geant4 sources and LDMX software sources should be obtained from GIT. Build scripts look
for sources in the `src/` directory:
```bash
cd src/
source checkout.sh
```

1. Define versions
In the `ldmx.buildvers` file you can define a different versions of LDMX and dependencies that are used.
Following is a description of the available options:
   * BOOST_VER=1.73.0 - Defines the boost version, builds most of the dependencies, against the selected python version (not tested fully currently)
   
   * PYTHON_VER=3.8.0 - Defines Python version, downloads the correct version and compiles with shared libraries (Currently not fully tested)

   * ONNX_VER=1.3.0 - Defines version of ONNX libraries, download the binaries without compiling them
   
   * ONNX_GPU=OFF - ON/OFF, Defines if the version of ONNX should be a GPU one (the ones available offer CUDA support) to run with the container need to use the -nv experimental option for CUDA support, CUDA support was not tested at this time
   
   * CENTOS=7 - defines the CentOS version. Currently only CentOS 7 builds are considered.

   * DEVTOOLSET=7 - defines the devloolset version to install. The value ‘S’ means system compilers usage without installing particular devtoolset pack. If you are not familiar with CetnOS devtools sets, you can interpret the number as GCC major version. 6, 7 and 8 are those you can try.

   * CMAKE_VER=3.17.3 - version of CMake. According to our experience the LDMX software and dependencies are very sensitive to CMake version. Do not change it if you do not have real reasons.

   * XERCES_VER=3.2.3 - version of Xerces-C. The latest and recommended is 3.2.3.

   * ROOTVERSION=6.20.04 - version of Root to build. Not all optional dependencies are build, can be on request

   * GEANT4_TAG=LDMX.10.2.3_v0.3 - Tag of LDMX-forked Geant4 source tree to build

   * LDMX_TAG=v2.0.0 - Tag of LDMX software to build, using latest gets the latest master

   * MAKEOPTS=-j8 - Additional options to pass to make command. Using -j #number-of-cores is recommended to speed-up build process.

   * MARCH=sandybridge - Optionally define instructions set optimization for the machine CPU type (e.g -march= CFLAG). It can improve performance but limit the portability. If not defined, general release compiler flags will be used.

## Building a dev version (Currently working with caveats if environment set up right at the end, still needs a bit of fixing)

Run build process `build-dev.sh` script will start the build process.
This will generate a Sandbox singularity image with all dependencies build 

Change the ownership of the container to be the current user by `chown -R $(id -u):$(id -g) ldmx-dev-test` if transfered to another machine some part of the system from the centos machine won't be transfered but the hability to build from inside the container will be preserved.

In order to run the sandbox use 
```bash
singularity shell -w ldmx-dev-test
```

Some sample scripts will be available in the container under /home for easy first setup

If for whatever reason you need to delete the folder, use the following commands
```bash
mkdir DeleteFolder && rsync -a --delete DeleteFolder/ ldmx-dev-test/;
rm -rf DeleteFolder && rm -rf ldmx-dev-test;
```
(add -v to rsync for verbose information on what is being deleted, there are many files it might take a little while but much faster than rm -rf)

To be completed...

## Building a prod version (realease s1.0.1 working with v2.1.0)

The `build-prod.sh` script will start the build process. First, it will generate intermediate singularity image with all dependencies build (except LDMX software itself). In case intermediate build image is already present in the working directory it will not be rebuilt again next time. This allows to update LDMX software with the same dependencies with much less efforts. The next step is to build the LDMX software and produce the “release” image that only contains runtime dependencies without build leftovers (like sources and build files). This release image should be used to run simulations.

4. Using LDMX release image
The LDMX singularity image already defines necessary environment variables for LDMX software and dependencies. So you can just run ldmx-sim or ldmx-app without any extra steps. The “run” command runs fire, so 
`singularity run ldmx.sif run.py`
or
`./ldmx.sif run.py`
is equivalent to
`singularity exec ldmx.sif fire run.py`

The image doesn’t include self-test functionality right now, that runs simple simulation with singularity (needs to be added)
