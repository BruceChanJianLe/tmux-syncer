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

# Unset window state
unset_win_option() {
  tmux set-option -wqu "$1"
}

# Show pane number
show_panes() {
  # -b to block
  # -N stops from swallowing keystroke
  # -d 0 keeps until we dismiss
  tmux display-panes -b -N -d 0 2> /dev/null
}

# Clear pane number
clear_panes() {
  # -d 1 to show only 1ms, hence, clears immediately
  tmux display-panes -b -d 1 2> /dev/null
}

# Re-arm into syncer mode
rearm_syncer() {
  show_panes
  tmux switch-client -T syncer
}

# Revert selected
revert_selection() {
  unset_win_option "$syncer_selected_option"
}
