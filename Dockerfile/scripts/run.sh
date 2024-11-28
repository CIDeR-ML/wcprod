#!/bin/bash

source /src/root/install/bin/thisroot.sh
source /src/geant4.10.03.p03/install/share/Geant4-10.3.3/geant4make/geant4make.sh
source /src/WCSim/build/bin/this_wcsim.sh
WCSim "$@"
