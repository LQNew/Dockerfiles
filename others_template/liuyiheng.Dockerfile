FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \
    CONDA_INSTALL="conda install -y" && \
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
# ==================================================================
# tools
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        apt-utils \
        build-essential \
        ca-certificates \
        cmake \
        sudo \
        wget \
        git \
        vim \
        htop \
        tmux \
        openssh-client \
        openssh-server \
        libboost-dev \
        libboost-thread-dev \
        libboost-filesystem-dev \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender-dev \
        && \
    conda config --set show_channel_urls yes && \
#   conda config --append channels conda-forge && \
#   conda config --append channels pytorch && \
    $CONDA_INSTALL \
        Cython \
        ffmpeg \
        h5py \
        future \
        pyyaml \
        cffi \
        Pillow \
        six \
        scipy \
        matplotlib \
        tqdm \
        scikit-learn \
        && \
    conda install -c conda-forge python-lmdb && \
    $PIP_INSTALL \
        opencv-python \
        opencv-contrib-python \
        seaborn \
        tabulate \
        portalocker \
        termcolor \ 
        visdom \
        metric-learn \
        prettytable \
        nibabel \
        pytest \
        wget \
        gym \
        yacs \
        munkres \
        && \
    conda clean -y --all && \
    visdom & sleep 180s ; kill $!  && \
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/* && \
# ==================================================================
# enable all users using sudo 
# ------------------------------------------------------------------
    cp /etc/sudoers /etc/sudoers.new && \
    echo "%users  ALL=(ALL:ALL) ALL" >> /etc/sudoers.new  && \
    visudo -c -f /etc/sudoers.new && \
    cp /etc/sudoers.new /etc/sudoers  && \
    rm /etc/sudoers.new
    

EXPOSE 6006
CMD ["/bin/bash"]