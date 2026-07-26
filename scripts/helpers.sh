#!/usr/bin/env bash

# Get global tmux server state
get_tmux_option() {
  local option="$1" default_value="$2" option_value
  option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

# Set global tmux server state
set_tmux_option() {
  tmux set-option -gq "$1" "$2"
}

# Get window state
get_win_option() {
  local option="$1" default_value="$2" v
  v=$(tmux show-option -wqv "option")
  if [ -z "$v" ]; then
    echo "$default_value"
  else
    echo "$v"
  fi
}

# Set window state
set_win_option() {
  tmux set-option -wq "$1" "$2"
}
