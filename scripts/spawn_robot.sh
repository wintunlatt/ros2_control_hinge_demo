#!/usr/bin/env bash
set -e
source ~/ws_ros2/install/setup.bash
# wait for /spawn_entity
until ros2 service list | grep -q /spawn_entity ; do sleep 0.2; done
ros2 service call /delete_entity gazebo_msgs/srv/DeleteEntity "{name: 'test_robot'}" || true
sleep 0.3
exec ros2 run gazebo_ros spawn_entity.py \
  -file "/home/wintunlatt/ws_ros2/install/test_control/share/test_control/urdf/test.urdf" \
  -entity test_robot
