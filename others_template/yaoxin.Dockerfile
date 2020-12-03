FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
LABEL maintainer "yaoxin <here@where.com>"
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
# install necessary
    apt-get update && apt-get install -y software-properties-common apt-utils wget && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python2.7 python2.7-dev python-pip && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3.6 python3.6-dev python3.6-tk python3-distutils-extra && \
    ln -s /usr/bin/python3.6-config /usr/local/bin/python3-config && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libfreetype6-dev \
    libzmq3-dev \
    python-numpy \
    python-dev \
    python-opengl \
    python-opencv \
    libjpeg-dev \
    xvfb \
    xorg-dev \
    libboost-all-dev \
    libsdl2-dev \
    swig \
    libgtk2.0-dev \
    aptitude \
    pkg-config \
    qtbase5-dev \
    libqt5opengl5-dev \
    libassimp-dev \
    libboost-python-dev \
    libtinyxml-dev \
    golang \
    terminator \
    libcanberra-gtk-module \
    libfuse2 \
    libnss3 \
    fuse \
    libglfw3-dev \
    xpra \
    xserver-xorg-dev \
    libffi-dev \
    libxslt1.1 \
    feedgnuplot \
    libglew-dev \
    parallel \
    apt-transport-https \
    build-essential ca-certificates \
	sudo ssh curl expect openssh-server \
    cmake locales htop vim git tmux ranger ffmpeg ttf-wqy-zenhei \
    libosmesa6-dev libgl1-mesa-glx libglfw3 libgl1-mesa-dev libopenmpi-dev zlib1g-dev libpcre16-3 libsm6 libxext6 libxrender-dev \
    net-tools zip rar unzip unrar patchelf && \
#    language
    locale-gen en_US.UTF-8 zh_CN.UTF-8 && \
    sed -i '$a\LANG="en_US.UTF-8"\nLC_CTYPE="en_US.UTF-8"\nLC_NUMERIC="zh_CN.UTF-8"\nLC_TIME="zh_CN.UTF-8"\nLC_COLLATE="en_US.UTF-8"\nLC_MONETARY="zh_CN.UTF-8"\nLC_MESSAGES="en_US.UTF-8"\nLC_PAPER="zh_CN.UTF-8"\nLC_NAME="zh_CN.UTF-8"\nLC_ADDRESS="zh_CN.UTF-8"\nLC_TELEPHONE="zh_CN.UTF-8"\nLC_MEASUREMENT="zh_CN.UTF-8"\nLC_IDENTIFICATION="zh_CN.UTF-8"' /etc/default/locale && \
    # config ssh
#    sed -i 's/.*PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
#    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/*
RUN wget -O ~/get-pip.py 192.168.101.120:8000/get-pip.py && \
#    wget -O ~/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    rm ~/get-pip.py && \
    python3 -m pip install pip -U && \
    pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple && \
    pip3 install --upgrade pip && \
    pip3 --no-cache-dir install --upgrade \
        tensorflow-gpu==1.14.0 tensorboard==1.14.0 && \
    pip3 --no-cache-dir install --upgrade \
        setuptools \
        numpy \
        scipy \
        pandas \
        cloudpickle \
        scikit-learn \
        matplotlib \
        opencv-python \
        Cython \
        gym[atari] roboschool ranger-fm \
        scikit-image plotly jupyter ipykernel jupyterlab sklearn Pillow \
        empy \
        tqdm \
        pyopengl \
        ipdb \
        imageio \
        mpi4py \
        jsonpickle \
        gtimer \
        path.py \
        cached-property \
        flask \
        joblib \
        six \
        pyprind \
        virtualenv glog psutil pgrep \
        future \
        protobuf \
        pyyaml \
        typing \
        torch \
        torchvision \
        visdom \
        seaborn \
        glfw imageio pycparser cffi lockfile absl-py stable-baselines && \
    rm -rf /var/lib/apt/lists/* /tmp/*
RUN USER=docker && \
    GROUP=docker && \
    LOCALHOST=192.168.101.120:8000  && \
    mkdir -p /home/$USER/.config /home/$USER/.local/bin /opt/pythonlib /root/.vnc&& \
    addgroup --gid 999999 $GROUP && \
    useradd --uid 999999 -g $GROUP -ms /bin/bash $USER && \
    adduser $USER sudo && \
    cp -r /root/.config/pip /home/$USER/.config/pip && \
#    fixuid
    wget $LOCALHOST/fixuid -P /usr/local/bin && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths:\n  - /home/$USER" > /etc/fixuid/config.yml && \
#    set sudo no passwd
    sed --in-place '26,$s/ALL$/NOPASSWD: ALL/' /etc/sudoers && \
#    set bashrc
    cp /etc/skel/.bashrc /home/$USER/ && \
    sed -i '$a\export PATH=$HOME/.local/bin:$PATH' /home/$USER/.bashrc && \
#    set ranger
    wget $LOCALHOST/bashrcnew && \
    cat bashrcnew >> /home/$USER/.bashrc && \
    rm bashrcnew && \
    wget $LOCALHOST/rc.conf -P /home/$USER/.config && \
#    for pythonlib
#    for baselines
    cd /opt/pythonlib && \
    wget -qO- $LOCALHOST/baselines.tar | tar xf -  && \
    cd baselines && \
    pip3 install -e . && \
#    for libfaketime
    cd /opt/pythonlib && \
    wget -qO- $LOCALHOST/libfaketime.tar | tar xf -  && \
    cd libfaketime/src && \
    make install && \
    rm -rf libfaketime && \
#    for spinning up
    cd /opt/pythonlib && \
    wget -qO- $LOCALHOST/spinningup.tar | tar xf -  && \
    cd spinningup && \
    pip install -e . && \
    chown -R $USER:$USER /home/$USER/ && \
#    for pycharm
    mkdir -p /opt/software/PyCharm && \
    cd /opt/software/PyCharm && \
    wget -qO- $LOCALHOST/pycharm-2018.3.5.tar | tar xf -  && \
    chmod -R 777 pycharm-2018.3.5 && \
    ln -s /opt/software/PyCharm/pycharm-2018.3.5/bin/pycharm.sh /home/$USER/.local/bin/pycharm && \
    chmod +x /home/$USER/.local/bin/pycharm && \
    chown -R $USER:$USER /home/$USER/ && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/*
#    for mujoco
USER docker:docker
#ENV
RUN USER=docker && \
    GROUP=docker && \
    LOCALHOST=192.168.101.120:8000  && \
    sudo chown -R $USER:$USER /home/docker && \
    mkdir -p /home/$USER/.mujoco && \
    cd /home/$USER/.mujoco && \
    sed -i '$a\export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mjpro150/bin' /home/$USER/.bashrc && \
    sed -i '$a\export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco200/bin' /home/$USER/.bashrc && \
    wget -qO- $LOCALHOST/mjpro150.tar | tar xf -  && \
    wget -qO- $LOCALHOST/mujoco200.tar | tar xf -  && \
    wget $LOCALHOST/mjkey.txt -P /home/$USER/.mujoco && \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco200/bin pip3 --no-cache-dir install --upgrade \
        mujoco-py --user && \
    sudo pip3 --no-cache-dir install --upgrade enum34 && \
    sudo apt-get clean && \
    sudo apt-get autoremove && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/*
RUN USER=docker && \
    GROUP=docker && \
    LOCALHOST=192.168.101.120:8000 && \
    sudo wget $LOCALHOST/entrypoint.sh -P / && \
    sudo chmod +x /entrypoint.sh && \
    cat /entrypoint.sh && \
    sudo apt update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y vnc4server xfce4 x11vnc mplayer gedit vlc iputils-ping qt5-default mesa-utils && \
#    mesa-utils ??
    wget $LOCALHOST/xstartup -P /home/$USER/.vnc && \
    chmod +x /home/$USER/.vnc/xstartup && \
    wget $LOCALHOST/xfce4-keyboard-shortcuts.xml -P /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml && \
    sudo chown -R $USER:$USER /home/$USER/ && \
    sudo apt-get clean && \
    sudo apt-get autoremove && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/*
USER root:root
#ENTRYPOINT ["/entrypoint.sh"]

