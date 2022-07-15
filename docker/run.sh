#!/bin/bash
docker run --net=host -it --rm \
           --privileged \
           --gpus all \
           -e DISPLAY=$DISPLAY \
           -v $HOME/.Xauthority:/root/.Xauthority \
           -v $(realpath ..):/root/catkin_ws/src/D-LIOM \
           $@ \
           dliom

