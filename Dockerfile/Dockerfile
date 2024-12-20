FROM seanxia8/cider-dataprod_24.10.23

LABEL maintainer="junjie"
LABEL contact="junjie.xia@ipmu.jp"
LABEL type="cpu"
LABEL version="ub20.04-wcsim-wcprod"

ARG DEBIAN_FRONTEND=noninteractive

ENV XDG_RUNTIME_DIR=/tmp/$USER

#wcprod
RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y install dpkg-dev cmake g++ gcc binutils git wget curl emacs vim openssh-client krb5-user && \
    apt-get -y install libx11-dev libxpm-dev libxft-dev libxext-dev libssl-dev && \
    apt-get -y install python3-dev python3-tk python3-pip python3-setuptools && \
    apt-get -y install libopenblas-dev libxerces-c-dev libyaml-cpp-dev zsh && \
    apt-get -y install screen tmux && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    pip3 --no-cache-dir install -U pip && \
    pip3 --no-cache-dir install --upgrade setuptools numpy pyyaml pytest tqdm pandas plotly jupyter matplotlib h5py uproot3 awkward memory_profiler line_profiler fire && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN mkdir -p /app && cd /app && \
    if [ -d wcprod_cider ]; then rm -rf wcprod_cider; fi && \ 
    git clone -b prod_v1.0 https://github.com/CIDeR-ML/wcprod.git wcprod_cider && cd wcprod_cider && \
    pip3 --no-cache-dir install --upgrade .

#datatool
RUN cd /app && \
    if [ -d CIDeR_DT ]; then rm -rf CIDeR_DT; fi && \  
    git clone -b prod_v1.0 https://github.com/CIDeR-ML/CIDeR_DT.git && cd CIDeR_DT

RUN apt-get -y install libspdlog-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

SHELL ["/bin/bash", "-c"]

# extra root, geant4, datatools deps
RUN apt-get install -y libexpat1-dev libxmu-dev libxi-dev libopengl-dev libxerces-c-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN mkdir -p /src && mkdir -p /src/scripts

WORKDIR /src

# hepmc3
RUN if [ ! -d hepmc3-build ]; then \
    wget http://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.2.6.tar.gz && \
    tar -xzf HepMC3-3.2.6.tar.gz && rm HepMC3-3.2.6.tar.gz && \
    mkdir hepmc3-build && cd hepmc3-build && \
    cmake   -DCMAKE_INSTALL_PREFIX=../hepmc3-install \
            -DHEPMC3_ENABLE_ROOTIO:BOOL=OFF \
            -DHEPMC3_ENABLE_PROTOBUFIO:BOOL=OFF \
            -DHEPMC3_ENABLE_TEST:BOOL=OFF \
            -DHEPMC3_INSTALL_INTERFACES:BOOL=ON \
            -DHEPMC3_BUILD_STATIC_LIBS:BOOL=OFF \
            -DHEPMC3_BUILD_DOCS:BOOL=OFF \
            -DHEPMC3_BUILD_EXAMPLES:BOOL=OFF \
            -DHEPMC3_INSTALL_EXAMPLES:BOOL=OFF \
            -DHEPMC3_ENABLE_PYTHON:BOOL=OFF \
            ../HepMC3-3.2.6 && \
    make -j$(nproc) && make install; \
    fi
    

# wcsim
ENV WCSIMDIR=/src/WCSim
ENV G4WORKDIR=/src/WCSim/exe
ENV GEANT4_BASE_DIR=/src/geant4.10.03.p03/install
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+"$LD_LIBRARY_PATH:"}${G4LIB}/${G4SYSTEM}

# clone and patch the code
RUN if [ -d WCSim ]; then rm -rf WCSim; fi && \ 
    git clone -b prod_v1.0 https://github.com/CIDeR-ML/WCSim.git && cd WCSim

# build with cmake
RUN cd WCSim && mkdir -p scripts && \
    source /src/root/install/bin/thisroot.sh && \
    source ${GEANT4_BASE_DIR}/share/Geant4-10.3.3/geant4make/geant4make.sh && \
    if [ -d build ]; then rm -rf build; fi && \ 
    mkdir build && \
    cd build && \
    cmake .. -DHepMC3_DIR=/src/hepmc3-install/share/HepMC3/cmake/ && \
    make -j$(nproc) && make install

COPY scripts/run.sh /src/WCSim/scripts/run.sh
COPY scripts/sourceme.sh /src/scripts/sourceme.sh
RUN chmod +x /src/WCSim/scripts/run.sh

RUN mkdir -p /work

WORKDIR /work

ENTRYPOINT ["/src/WCSim/scripts/run.sh"]
