#!/usr/bin/env bash
set -e

BASE=~/ros2_control_hinge_demo
# Make sure scripts are executable
chmod +x "$BASE"/scripts/*.sh

# Open separate Windows Terminal tabs that run WSL commands
wt.exe -w 0 nt --title "Gazebo"      wsl.exe -e bash -lc "source $BASE/install/setup.bash; bash $BASE/scripts/run_gazebo.sh"
sleep 1
wt.exe -w 0 nt --title "RSP"         wsl.exe -e bash -lc "source $BASE/install/setup.bash; bash $BASE/scripts/run_rsp.sh"
sleep 1
wt.exe -w 0 nt --title "Spawn"       wsl.exe -e bash -lc "source $BASE/install/setup.bash; bash $BASE/scripts/spawn_robot.sh"
sleep 2
wt.exe -w 0 nt --title "Controllers" wsl.exe -e bash -lc "source $BASE/install/setup.bash; bash $BASE/scripts/start_controllers.sh"

# Optional: open a tab that diagnoses and jogs automatically
# wt.exe -w 0 nt --title "Jog"      wsl.exe -e bash -lc "source $BASE/install/setup.bash; bash $BASE/scripts/diagnose_and_jog.sh"
