#!/usr/bin/env bash
set -e
source ~/ws_ros2/install/setup.bash
# kill previous RSP
pkill -9 robot_state_publisher 2>/dev/null || true
exec ros2 run robot_state_publisher robot_state_publisher \
  --ros-args --params-file ~/ws_ros2/install/test_control/share/test_control/config/rsp.yaml
