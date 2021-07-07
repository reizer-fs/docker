FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y upgrade
RUN apt install -y --no-install-recommends libnuma-dev gnupg2 nano wget ca-certificates python3-pip

RUN wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add -
RUN echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ xenial main' | tee /etc/apt/sources.list.d/rocm.list
RUN apt update

RUN groupadd render
RUN usermod -a -G video root && usermod -a -G render root
RUN mkdir --parents /etc/udev/rules.d
RUN echo 'SUBSYSTEM=="kfd", KERNEL=="kfd", TAG+="uaccess", GROUP="video"' |tee /etc/udev/rules.d/70-kfd.rules

RUN apt install -y miopen-hip4.0.0 hipblas4.0.0 hipsparse4.0.0 rccl4.0.0 roctracer-dev4.0.0 rocm-libs4.0.0 rocm-smi4.0.0 miopengemm4.0.0
RUN cp /opt/rocm-4.0.0/hip/lib/libamdhip64.so.4.0.40000 /lib/libamdhip64.so.3
RUN find /opt/rocm-4.0.0/ -type d | grep 'lib$' > /etc/ld.so.conf.d/rocm.conf
RUN ldconfig -v

ENV ETH_WALLET=<your_ethereum_wallet_address>
ENV WORKERNAME=some_workername
RUN cd /root && mkdir ethminer && cd ethminer && wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-9-linux-x86_64.tar.gz && tar xzvf ethminer-0.18.0-cuda-9-linux-x86_64.tar.gz
RUN printf '#!/bin/bash\n./root/ethminer/bin/ethminer -P stratum1+tcp://${ETH_WALLET}.${WORKERNAME}@eu1.ethpool.org:3333' >> /usr/bin/run_ethminer && chmod +x /usr/bin/run_ethminer
