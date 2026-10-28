# spar_lab_gripper_client

## Overview
Repository for the first lab exercise of FER course "Robotic Sensors, Perception, and Actuation" (https://www.fer.unizg.hr/en/course/rspaa).
The repository contains a docker image (in case you want to use it), two python scripts and a custom service message.

## Preparation
Review ROS2 tutorials and lecture slides.
If you haven't already done so, set up a ROS2 Jazzy environment.

The simplest way to set it up is to create a Jazzy workspace on a native Ubuntu 22.04.
Our preferred method is to set up a docker container.

Clone this git repository in your ROS2 workspace:

```
git clone https://github.com/larics/spar_lab_gripper_client
```

**Before attending the exercise, you must complete the preliminary task defined in this repository and submit it to Moodle by the deadline**.

## Preliminary task

Your task is to implement service calls in `src/dynamixel_client.py`.

Two services use a custom message defined in `srv/GripperState.srv`.
You may use a mock server defined in `src/dynamixel_server_mock.py` to validate your client implementation.

## Docker instructions
This is a quick guide on creating a docker container for the lab exercises, if you have a native Ubuntu 24.04 with ROS2 Jazzy you do not need this.

To run a docker container, use the following commands in the root directory of this repository:
```
docker build -t rspaa_lab -f rspaa_lab.Dockerfile  .
docker run -it \
    --privileged \
    -v /dev:/dev \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=/root/.Xauthority \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $XAUTHORITY:/root/.Xauthority \
    rspaa_lab
```
To briefly explain the flags, `-v /dev:/dev` is needed to grant access to usb for the servo motor and the rest are needed to allow opening of new windows useful for another lab exercise.

Here are some common commands:
- `docker ps`: Shows the currently running containers.
- `docker ps -a`: Shows all containers, including stopped ones.
- `docker images`: Shows the available Docker images.
- `docker start rspaa_lab`: Starts an existing container.
- `docker stop rspaa_lab`: Stops a running container.
- `docker restart rspaa_lab`: Restarts a container.
- `docker rm rspaa_lab`: Deletes a stopped container.
- `docker rm -f rspaa_lab`: Forcibly stops and deletes a container.
- `docker exec -it rspaa_lab bash`: Opens a terminal inside a running container.
- `docker logs rspaa_lab`: Shows the container's output log.

Docker Cheat Sheet: <https://docs.docker.com/get-started/docker_cheatsheet.pdf>
