#!/usr/bin/env bash
# To group selected panes

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

sel=$(get_win_option "$syncer_selected_option" "")
# shellcheck disable=SC2086
set -- $sel
count=$#

# Grouping requires at least 2 panes
if [ "$count" -lt 2 ]; then
  revert_selection
  tmux display-message "syncer: grouping requires at least 2 panes (cancelled)"
  exit 0
fi

# Remove the pane number
clear_panes

origin=$(tmux display-message -p '#{window_id}')
set_win_option "$syncer_origin_option" "$origin"

# Obtain snapshot of current window layout
set_win_option "$syncer_original_layout_option" "$(tmux display-message -p '#{window_layout}')"

# Move unselected panes into hidden window
hold=""
for id in $(tmux list-panes -F '#{pane_id}'); do
  if ! list_contains "$sel" "$id"; then
    if [ -z "$hold" ]; then
      hold=$(tmux break-pane -d -s "$id" -P -F '#{window_id}')
    else
      tmux join-pane -d -s "$id" -t "$hold"
    fi
  fi
done

# empty if all selected
set_win_option "$syncer_active_option" "$hold"

tmux select-layout tiled

# undim selected style
revert_selection

tmux display-message "syncer: grouped $count panes - ungroup with prefix + G"
