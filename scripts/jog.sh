#!/usr/bin/env bash
set -e
source ~/ws_ros2/install/setup.bash
# Wait for controller topic to be available
until ros2 topic list | grep -q /hinge_position_controller/command ; do sleep 0.2; done
# Send a couple of positions
ros2 topic pub /hinge_position_controller/command std_msgs/msg/Float64 "data: 0.6" -1
sleep 1
ros2 topic pub /hinge_position_controller/command std_msgs/msg/Float64 "data: -0.5" -1
