# ros2_control_hinge_demo

Minimal ROS 2 (Humble) + **Gazebo Classic** demo showing a single revolute joint driven by **ros2_control**.  
Includes WSL helper scripts and an optional Windows `.bat` launcher.

## Contents
- `src/test_control` — ROS 2 package (URDF, ros2_control config, params)  
- `scripts/` — WSL helper scripts for Gazebo, RSP, spawn, controllers, jog  
- `run_sim.bat` — Windows launcher that opens multiple terminals (optional)

> Gazebo Classic is EOL; this demo is for learning. Porting to Gazebo (Fortress/Harmonic) later is straightforward.

---

## Quick Start (WSL + Humble)

```bash
cd ~/ros2_control_hinge_demo
colcon build --packages-select test_control
source install/setup.bash
```

### One-click (Windows)
Double-click `run_sim.bat` (if you copied it to your Desktop), or from WSL:
```bash
cmd.exe /c "%USERPROFILE%\Desktop\run_sim.bat"
```

### Manual (open 4 WSL terminals)

**A: Gazebo**
```bash
bash scripts/run_gazebo.sh
```

**B: robot_state_publisher**
```bash
bash scripts/run_rsp.sh
```

**C: Spawn the robot**
```bash
bash scripts/spawn_robot.sh
```

**D: Start controllers**
```bash
bash scripts/start_controllers.sh
```

### Jog the joint

```bash
# ForwardCommandController expects Float64MultiArray
ros2 topic pub /hinge_position_controller/commands std_msgs/msg/Float64MultiArray "data: [0.6]" -1
sleep 1
ros2 topic pub /hinge_position_controller/commands std_msgs/msg/Float64MultiArray "data: [-0.6]" -1
```

---

## One-click launchers (WSL)

### A) Windows Terminal tabs (recommended on Windows)
Runs each step in its own Windows Terminal tab using `wt.exe`:
```bash
bash scripts/run_all_wsl_tabs.sh
```

### B) tmux (all panes in one WSL window)
Install tmux once, then launch all panes in one window:
```bash
sudo apt-get update && sudo apt-get install -y tmux
bash scripts/run_all_tmux.sh
```

---

## Troubleshooting

- If publishing says **“Waiting for at least 1 matching subscription(s)…”**, the subscriber isn’t up yet:
  ```bash
  bash scripts/diagnose_and_jog.sh
  ```
- If controllers are **`unconfigured`**, (re)spawn with params:
  ```bash
  ros2 run controller_manager spawner joint_state_broadcaster --controller-manager-timeout 30
  ros2 run controller_manager spawner hinge_position_controller     --controller-manager-timeout 30     --param-file install/test_control/share/test_control/config/hinge_forward_params.yaml
  ```
- See joint numerically:
  ```bash
  ros2 topic echo /joint_states
  ```

---

## Notes

- Files are installed via the `test_control` package so scripts can reference  
  `install/test_control/share/test_control/...` (or `$(ros2 pkg prefix test_control)/share/test_control/...`).
- This demo uses:
  - `forward_command_controller/ForwardCommandController`
  - `joint_state_broadcaster/JointStateBroadcaster`
