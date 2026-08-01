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
  v=$(tmux show-option -wqv "$option")
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
  # -b non blocking
  # -N passive (stops from swallowing keystroke)
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

# Revert selected (clear the selected styles as well)
revert_selection() {
  local id
  for id in $(tmux list-panes -F '#{pane_id}'); do
    tmux set-option -pu -t "$id" window-style 2> /dev/null
  done
  clear_panes
  unset_win_option "$syncer_selected_option"
}

# space delimited id-set utils

list_contains() {
  case " $1 " in
    *" $2 "*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

add_id() {
  echo " $1 $2 " | tr ' ' '\n' | grep -v '^$' | sort -u | tr '\n' ' ' | sed 's/^ *//;s/ *$//'
}

remove_id() {
  echo " $1 " | sed "s/ $2 / /g" | sed 's@^ *//;s@ *$//'
}

# add or remove pane
toggle_pane() {
  local pane_id="$1" sel dim
  sel=$(get_win_option "$syncer_selected_option")
  dim=$(get_tmux_option "$syncer_selected_style_option" "$syncer_selected_style_default")

  if list_contains "$sel" "$pane_id"; then
    sel=$(remove_id "$sel" "$pane_id")
    tmux set-option -pu -t "$pane_id" window-style 2> /dev/null
  else
    sel=$(add_id "$sel" "$pane_id")
    tmux set-option -p -t "$pane_id" window-style "$dim"
  fi

  set_win_option "$syncer_selected_option" "$sel"
}

# Restore the original layout (fallback to tiled if failed)
restore_layout() {
  local win="$1" layout="$2" desired i want cur
  [ -z "$layout" ] && { tmux select-layout -t "$win" tiled 2> /dev/null; return; }

  # Pane ids are the 4th field of each leaf: WxH,x,y,ID
  desired=$(printf '%s\n' "$layout" | grep -oE '[0-9]+x[0-9]+,[0-9]+,[0-9]+,[0-9]+' | awk -F, '{print $4}')
  i=1
  for want in $desired; do
    cur=$(tmux list-panes -t "$win" -F '#{pane_id}' | sed -n "${i}p") # i-th pane, base-index safe
    if [ -n "$cur" ] && [ "%$want" != "$cur" ]; then
      tmux swap-pane -d -s "%$want" -t "$cur" 2> /dev/null || true
    fi
    i=$((i + 1))
  done

  tmux select-layout -t "$win" "$layout" 2> /dev/null || tmux select-layout -t "$win" tiled 2> /dev/null
}
