#!/bin/bash

if [ -d "./build" ] || [ -d "./devel" ]; then
  echo "Remove old build files(y/n)?"
  read x
  if [ $x = "y" ]; then
    echo "Removing old build files.."
    rm -rf ./build
    rm -rf ./devel
  fi
fi

catkin_make
source ./devel/setup.bash
roslaunch agents_gazebo agents_gazebo.launch
