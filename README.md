## Dockerfiles for DeepRL research.
### Dependency
- If you want to build docker images which support mujoco, you need `mjkey.txt` for building the docker images. You can also customize the dockerfile upon our dockerfiles.
- See the directory `Dockerfiles` for more details.
### Recommendation
- If your machine can work on **CUDA 10.0**, we recommend for reading the `dmc-mujoco-atari-torch1.4-tf1.14-cu100` dockerfile. The image built by `dmc-mujoco-atari-torch1.4-tf1.14-cu100` dockerfile contains:
  - DeepMind Control Suite
  - MuJoCo 200
  - Atari
  - CUDA 10.0
  - Torch 1.4
  - Tensorflow 1.14

- If your machine only works on **CUDA 11.x**, we recommend for reading the `dmc-mujoco-atari-torch1.7-cu110` dockerfile. The image built by `dmc-mujoco-atari-torch1.7-cu110` dockerfile contains:
  - DeepMind Control Suite
  - MuJoCo 200
  - Atari
  - CUDA 11.0
  - Torch 1.7.1
  - ~~Tensorflow~~

### Usage of Tmux in our Docker
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

- As the user (non-root, recommend this way <br>Example script:
  ```bash
  docker run --gpus all -itd --user $(id -u ${USER}):$(id -g ${USER}) --rm --name [container_name] \
    -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro -v /etc/shadow:/etc/shadow:ro -v /home/${USER}:/home/${USER}:ro \
    -v [local-dir]:/share \
    -it [image_name] /bin/bash
  ```
