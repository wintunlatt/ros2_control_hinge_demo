@echo off
REM One-click launcher for WSL ROS2 + Gazebo + controllers

REM Start Gazebo (Terminal A)
start "Gazebo" wt.exe -w 0 nt -p "Command Prompt" cmd /k wsl.exe -e bash -lc "bash ~/ws_ros2/scripts/run_gazebo.sh"
timeout /t 2 /nobreak >NUL

REM Start robot_state_publisher (Terminal B)
start "RSP" wt.exe -w 0 nt -p "Command Prompt" cmd /k wsl.exe -e bash -lc "bash ~/ws_ros2/scripts/run_rsp.sh"
timeout /t 2 /nobreak >NUL

REM Spawn the robot (Terminal C)
start "Spawn" wt.exe -w 0 nt -p "Command Prompt" cmd /k wsl.exe -e bash -lc "bash ~/ws_ros2/scripts/spawn_robot.sh"
timeout /t 3 /nobreak >NUL

REM Start controllers (Terminal D)
start "Controllers" wt.exe -w 0 nt -p "Command Prompt" cmd /k wsl.exe -e bash -lc "bash ~/ws_ros2/scripts/start_controllers.sh"
timeout /t 2 /nobreak >NUL

REM Optional: Jog the joint (Terminal E)
start "Jog" wt.exe -w 0 nt -p "Command Prompt" cmd /k wsl.exe -e bash -lc "bash ~/ws_ros2/scripts/jog.sh"
