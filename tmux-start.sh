#!/usr/bin/env bash

# ---- CONFIG ----
ROBOT_PI=~/projects/club/robocup2026-raspberrypi-program
ROBOT_ESP=~/projects/club/robocup2026-esp32-program

# ---- ROBOT SESSION ----
if ! tmux has-session -t robot 2>/dev/null; then
  # Create session with first window
  tmux new-session -d -s robot -n main

  # Split layout:
  # Start with one pane -> split right -> split left bottom
  tmux split-window -h -t robot:main        # creates right pane
  tmux split-window -v -t robot:main.0      # split left into top/bottom

  # Navigate panes
  tmux send-keys -t robot:main.0 "cd $ROBOT_PI" C-m
  tmux send-keys -t robot:main.1 "cd $ROBOT_ESP" C-m
  tmux send-keys -t robot:main.2 "cd ~" C-m

  # ---- Additional windows ----
  tmux new-window -t robot -n rpi
  tmux send-keys -t robot:rpi "cd $ROBOT_PI" C-m

  tmux new-window -t robot -n esp32
  tmux send-keys -t robot:esp32 "cd $ROBOT_ESP" C-m

  tmux new-window -t robot -n home
  tmux send-keys -t robot:home "cd ~" C-m
fi


# ---- PERSONAL SESSION ----
if ! tmux has-session -t personal 2>/dev/null; then
  tmux new-session -d -s personal -n main
  tmux send-keys -t personal:main "cd ~" C-m
fi
