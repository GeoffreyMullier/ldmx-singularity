#!/bin/bash

rm -rf ldmx-geant4
rm -rf ldmx-git
rm -rf MagFieldMap

git clone --recursive https://github.com/LDMX-Software/geant4.git ldmx-geant4

# those are currently privat repos that requires credentials

git clone --recursive https://github.com/LDMXAnalysis/ldmx-sw.git ldmx-git
git clone --recursive https://github.com/LDMXAnalysis/MagFieldMap MagFieldMap

