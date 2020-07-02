# Building from source

_This section is about building tricks to build from source, bare metal on Centos, though most of the findings can be also adapted to other systems_

**This file is a work in progress and hopefully will grow more complete as things advance.**

## Python

For building python and getting all dependencies right I followed some recipes that can be found below

https://stackoverflow.com/questions/49763362/cant-build-optional-modules-readline-and-curses-when-compiling-python3-4-from
https://docs.rstudio.com/resources/install-python-source/

In addition in the script I basically set that python not in the original location that the system would see but in /opt/pythonX (where X is the version)

The reason for this was to avoid having problems with system version of python, this is not an issue

In this particular case the bootstrap would find the gcc version given by devtoolset since the environment links everything to the "right" version of gcc. 
I am suspecting that in a case where there is an alternate version of gcc one might need to specify which one would be the usual suspect, I haven't looked into it but that should come in a bit

N.B. The method I use currently to add the python3 executable and libraries to the global environment PATH and LD_PATH sort of assumes that python3 is not installed on the system, there might be therefore a mismatch between those executables if there is already a system-wide install of python3, one could use the system-wide dev version, but I like it from source.

## Boost

Building boost from source can be headache inducing, especially because in theory the boost developers wants you to modify the `user-config.jam` in order to compile 

This being said, in the definition script, I list a method that was found by someone to define the required parameters

## CMake

Normally the script is working quite OK for this, there are some subtleties requiering you to use a more recent version of cmake in order to make the whole thing work.

There was a bug in previous version of FindPythonInterpreter module of cmake, causing it to detect the wrong version of the python interpreter, it would see python interpreter 1.4 instead of whatever version you would have if you were using an externally compiled version of python with respect to the system one

## Geant4

Normally if the other dependencies are building normally this should build alright with the options passed to cmake

## ROOT

Normally if the other dependencies are building fine this one shouldn't be an issue
