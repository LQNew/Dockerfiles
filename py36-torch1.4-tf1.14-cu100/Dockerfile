# ==================================================================
# module list
# ------------------------------------------------------------------
# python        3.6    
# pytorch       1.4.0  (pip)
# tensorflow    1.14.0 
# ==================================================================
FROM tensorflow/tensorflow:1.14.0-gpu-py3

ENV LANG C.UTF-8

RUN sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list && \
    APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade --default-timeout 100" && \
    GIT_CLONE="git clone --depth 10" && \
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
# ==================================================================
# tools
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        apt-utils \
        ca-certificates \
        wget \
        git \
        vim \
        libssl-dev \
        curl \
        unzip \
        unrar \
        && \
# ==================================================================
# python
# ------------------------------------------------------------------
    $PIP_INSTALL \
        pip \
        setuptools \
        numpy \
        scipy \
        pandas \
        cloudpickle \
        scikit-image>=0.14.2 \
        scikit-learn \
        matplotlib \
        Cython \
        tqdm \
        && \
# ==================================================================
# pytorch
# ------------------------------------------------------------------
    $PIP_INSTALL \
        future \
        protobuf \
        pyyaml \
        typing \
        && \
    $PIP_INSTALL -i https://mirrors.aliyun.com/pypi/simple \
        torch==1.4.0 \
        torchvision==0.5.0 \
        && \
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*