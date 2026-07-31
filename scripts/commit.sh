#!/usr/bin/env bash
# Commit to sync selected panes and disable unselected panes

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

sel=$(get_win_option "$syncer_selected_option" "")
# Fallback to previous if none is selected
[ -z "$sel" ] && sel=$(get_win_option "$syncer_last_option" "")

# shellcheck disable=SC2086
set -- $sel
count=$#

if [ "$count" -lt 2 ]; then
  revert_selection
  tmux display-message "syncer: pick at least 2 panes to sync. (cancelled)"
  exit 0
fi

# Save current layout as last
set_win_option "$syncer_last_option" "$sel"

clear_panes

# loop through all unselected panes and disable them
for id in $(tmux list-panes -F '#{pane_id}'); do
  if list_contains "$sel" "$id"; then
    tmux select-pane -t "$id" -e
  else
    tmux select-pane -t "$id" -d
  fi
done

# sync all active panes
tmux set-option -w synchronize-panes on
tmux select-pane -t "$1" -e # focus on any selected pane

# disable pane style from selection mode
revert_selection
tmux display-message "syncer: synced $count panes, use prefix + V to unsync."
