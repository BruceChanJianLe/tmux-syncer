#!/usr/bin/env bash
# Commit to sync selected panes and disable unselected panes

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

sel=$(get_win_option "$syncer_selected_option" "")
# shellcheck disable=SC2086
set -- $sel
count=$#

if [ "$count" -lt 2 ]; then
  revert_selection
  tmux display-message "syncer: pick at least 2 panes to sync. (cancelled)"
  exit 0
fi

clear_panes

# loop through all unselected panes and disable them
for id in $(tmux list-panes -F '#{pane_id}'); do
  list_contains "$sel" "$id" || tmux select-pane -t "$id" -d
done

# sync all active panes
tmux set-option -w synchronize-panes on
tmux select-pane -t "$1" -e # focus on any selected pane

# disable pane style from selection mode
revert_selection
tmux display-message "syncer: synced $count panes, use prefix + V to unsync."
