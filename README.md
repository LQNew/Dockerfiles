## Dockerfiles for DeepRL research.
### Dependency
- ~~If you want to build docker images which support mujoco, you must need `mjkey.txt` for building the docker images. You can also customize the dockerfile upon our dockerfiles.~~
- I am grateful to DeepMind for making MuJoCo free. Now, I add the `mjkey.txt` to the corresponding folder, you can directly compile the dockerfile for running the MuJoCo environment. Also, you can customize the dockerfile upon our dockerfiles.
- See the directory `dmc-mujoco-atari-torch1.4-tf1.14-cu100`, `dmc-mujoco-atari-torch1.7-cu110`, etc, for more details.
### Recommendation
- If your machine can work on **CUDA 10.0** or **CUDA 10.1**, we recommend for reading the `dmc-mujoco-atari-torch1.4-tf1.14-cu100` or `dmc-mujoco-atari-torch1.5-tf1.14-cu101` dockerfile. The image built by `dmc-mujoco-atari-torch1.4-tf1.14-cu100` or `dmc-mujoco-atari-torch1.5-tf1.14-cu101` dockerfile contains:
  - DeepMind Control Suite
  - MuJoCo 200
  - Atari
  - CUDA 10.0 / CUDA 10.1
  - Torch 1.4 / Torch 1.5
  - Tensorflow 1.14

- If your machine only works on **CUDA 11.x**, we recommend for reading the `dmc-mujoco-atari-torch1.7-cu110` dockerfile. The image built by `dmc-mujoco-atari-torch1.7-cu110` dockerfile contains:
  - DeepMind Control Suite
  - MuJoCo 200
  - Atari
  - CUDA 11.0
  - Torch 1.7.1
  - ~~Tensorflow~~

### Ready-made Docker images
- We also provide our compiled docker images to help you run MuJoCo environment quickly.
  ```bash
  docker pull liqingya/mujoco:py36-torch1.4-tf1.14-cu100  # `mujoco-torch1.4-tf1.14-cu100`

  docker pull liqingya/mujoco:dmc-atari-py36-torch1.4-tf1.14-cu100  # `dmc-mujoco-atari-torch1.4-tf1.14-cu100`

  docker pull liqingya/mujoco:dmc-atari-py36-torch1.5-tf1.14-cu101  # `dmc-mujoco-atari-torch1.5-tf1.14-cu101`

  docker pull liqingya/mujoco:dmc-atari-py36-torch1.7-cu110  # dmc-mujoco-atari-torch1.7-cu110
  ```

### Usage of Tmux in our Docker
- We have added `.tmux.conf` to the docker image for customizing tmux usage:
  ```bash
  # Pane splitting commands
  Ctrl-a + v # split pane along vertical direction
  Ctrl-a + h # split pane along horizontal direction

  # Mouse mode for fast Pane-Switching
  # We can switch pane by simply clicking the pane through the mouse.

  # Switch out window
  Ctrl-a + d
  ```

### Start the Container
- As the root (not secure)<br>Example script:
  ```bash
  docker run --gpus all -itd --rm --name [container_name] \
    -v [local-dir]:/share \
    -it [image_name] /bin/zsh
  ```

- As the user (non-root, recommend this way) <br>Example script:
  ```bash
  docker run --gpus all -itd --user $(id -u ${USER}):$(id -g ${USER}) --rm --name [container_name] \
    -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro -v /etc/shadow:/etc/shadow:ro -v /home/${USER}:/home/${USER}:ro \
    -v [local-dir]:/share \
    -it [image_name] /bin/bash
  ```
  **For the usage of MuJoCo as the user in the docker container:**

  - Firstly, you should create `~/.mujoco` directory, and then move `mujoco_200` which unzipped from `mujoco200_linux.zip` and `mjkey.txt` to `~/.mujoco`:
    ```bash
    # cd to the `mujoco200_linux.zip` and 'mjkey.txt` location.
    mkdir -p ~/.mujoco && \
    unzip mujoco200_linux.zip && \
    mv mujoco200_linux ~/.mujoco/mujoco200_linux && \
    cp -r ~/.mujoco/mujoco200_linux ~/.mujoco/mujoco200 && \
    cp mjkey.txt ~/.mujoco/
    ```
  - Secondly, edit the bash file:
    ```bash
    vim ~/.bashrc
    ```
    And then add the following scripts to the end of the file:
    ```bash
    export LD_LIBRARY_PATH=~/.mujoco/mujoco200/bin${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
    export LD_LIBRARY_PATH=~/.mujoco/mujoco200_linux/bin${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
    export MUJOCO_KEY_PATH=~/.mujoco${MUJOCO_KEY_PATH}
    ```
  - Finally, after create container, enter the container and input the following script:
    ```bash
    sudo chmod 777 /usr/local/lib/python3.6/dist-packages/mujoco_py/generated/
    ```

