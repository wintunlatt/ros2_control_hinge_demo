#!/usr/bin/env bash
set -e

# Requires: sudo apt-get install -y tmux
BASE=~/ros2_control_hinge_demo
SESSION=ros2ctl

# Kill existing session if any
tmux has-session -t "$SESSION" 2>/dev/null && tmux kill-session -t "$SESSION"

tmux new-session  -d -s "$SESSION" "source $BASE/install/setup.bash; bash $BASE/scripts/run_gazebo.sh"
tmux split-window -v -t "$SESSION" "source $BASE/install/setup.bash; bash $BASE/scripts/run_rsp.sh"
tmux split-window -h -t "$SESSION":0.1 "source $BASE/install/setup.bash; bash $BASE/scripts/spawn_robot.sh"
tmux split-window -h -t "$SESSION":0.0 "source $BASE/install/setup.bash; bash $BASE/scripts/start_controllers.sh"
tmux select-layout -t "$SESSION":0 tiled
tmux attach -t "$SESSION"
