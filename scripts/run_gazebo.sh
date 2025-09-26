#!/usr/bin/env bash
set -e
source ~/ws_ros2/install/setup.bash
export GAZEBO_PLUGIN_PATH=/opt/ros/humble/lib:$GAZEBO_PLUGIN_PATH
# kill any previous instances
pkill -9 gzserver gzclient gazebo 2>/dev/null || true
exec gazebo --verbose -s libgazebo_ros_init.so -s libgazebo_ros_factory.so
