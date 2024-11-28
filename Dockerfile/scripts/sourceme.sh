#!/bin/bash

source /src/root/install/bin/thisroot.sh
source /src/geant4.10.03.p03/install/share/Geant4-10.3.3/geant4make/geant4make.sh
source /src/WCSim/build/bin/this_wcsim.sh
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+"$LD_LIBRARY_PATH:"}${G4LIB}/${G4SYSTEM}
# export G4WORKDIR=""
export WCSIMDIR=/src/WCSim/build
export DATATOOLS=/app/CIDeR_DT
export PYTHONPATH=$DATATOOLS:$PYTHONPATH
# /src/WCSim/exe/bin/Linux-g++/WCSim "$@"
