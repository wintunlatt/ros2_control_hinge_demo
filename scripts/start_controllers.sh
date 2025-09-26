#!/usr/bin/env bash
set -e
source ~/ws_ros2/install/setup.bash

# Wait for controller_manager node to exist
until ros2 node list | grep -q /controller_manager ; do sleep 0.2; done

# (Re)spawn JSB
ros2 control load_controller joint_state_broadcaster 2>/dev/null || true
ros2 control set_controller_state joint_state_broadcaster active 2>/dev/null || true

# Ensure clean slate for hinge controller
ros2 control set_controller_state hinge_position_controller inactive 2>/dev/null || true
ros2 control unload_controller hinge_position_controller 2>/dev/null || true

# Load & activate the single-joint position controller
ros2 control load_controller hinge_position_controller
ros2 control set_controller_state hinge_position_controller active

# Show status
ros2 control list_controllers
