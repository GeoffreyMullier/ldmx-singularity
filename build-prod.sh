#!/bin/bash

source ldmx.buildvers

if [ -n "$MARCH" ]; then
  export CFLAGS="-march=$MARCH"
  export CXXFLAGS="-march=$MARCH"
  IMGMARCH="-o$MARCH"
  SINGULARITY_OPTS="--notest "
fi

if [ ! -f "centos${CENTOS}.sif" ]; then
  sudo singularity build centos${CENTOS}.sif def/centos${CENTOS}.def
fi

ln -sf "centos${CENTOS}.sif" centos.sif

buildenv_img="ldmx-buildenv${IMGMARCH}-el${CENTOS}-c${CMAKE_VER}-d${DEVTOOLSET}-x${XERCES_VER}-g${GEANT4_TAG}-r${ROOTVERSION}-onnx${ONNX_VER}-gpu${ONNX_GPU}.sif"

if [ ! -f "$buildenv_img" ]; then
  sudo singularity build "$buildenv_img" def/ldmx-buildenv.def
fi

ln -sf "$buildenv_img" ldmx-buildenv.sif

# do not include XERCES and CMAKE version as we are not going to change those
ldmx_img="ldmx-${LDMX_TAG}${IMGMARCH}-g${GEANT4_TAG}-r${ROOTVERSION}-onnx${ONNX_VER}-gpu${ONNX_GPU}-el${CENTOS}-d${DEVTOOLSET}.sif"

sudo singularity build ${SINGULARITY_OPTS} "$ldmx_img" def/ldmx.def

