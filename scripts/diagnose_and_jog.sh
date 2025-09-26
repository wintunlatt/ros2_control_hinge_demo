#!/usr/bin/env bash
set -e
source ~/ws_ros2/install/setup.bash

echo "=== Controllers ==="
ros2 control list_controllers || true
echo

# Ensure controller_manager is up
until ros2 node list | grep -q /controller_manager ; do sleep 0.2; done

# Make sure JSB is running
if ! ros2 control list_controllers | grep -q "joint_state_broadcaster.*active"; then
  echo "[INFO] (Re)spawning joint_state_broadcaster..."
  ros2 control unload_controller joint_state_broadcaster 2>/dev/null || true
  ros2 run controller_manager spawner joint_state_broadcaster --controller-manager-timeout 30
fi

# Make sure hinge controller is active (ForwardCommandController)
if ! ros2 control list_controllers | grep -q "hinge_position_controller.*ForwardCommandController.*active"; then
  echo "[INFO] (Re)spawning hinge_position_controller with params..."
  ros2 control unload_controller hinge_position_controller 2>/dev/null || true
  ros2 run controller_manager spawner hinge_position_controller \
    --controller-manager-timeout 30 \
    --param-file ~/ws_ros2/install/test_control/share/test_control/config/hinge_forward_params.yaml
fi

echo
echo "=== Controllers (after) ==="
ros2 control list_controllers
echo

echo "=== Topics with hinge_ ==="
ros2 topic list | grep hinge_ || true
echo

# Wait for subscriber on /hinge_position_controller/commands
echo "[INFO] Waiting for /hinge_position_controller/commands to have a subscriber..."
for i in {1..50}; do
  SUBS=$(ros2 topic info /hinge_position_controller/commands | awk '/Subscription count:/{print $3}')
  if [ "$SUBS" != "" ] && [ "$SUBS" -gt 0 ]; then
    break
  fi
  sleep 0.2
done

ros2 topic info /hinge_position_controller/commands || true
echo

echo "[INFO] Jogging: +0.6 rad then -0.6 rad"
ros2 topic pub /hinge_position_controller/commands std_msgs/msg/Float64MultiArray "data: [0.6]" -1
sleep 1
ros2 topic pub /hinge_position_controller/commands std_msgs/msg/Float64MultiArray "data: [-0.6]" -1
echo "[DONE]"
