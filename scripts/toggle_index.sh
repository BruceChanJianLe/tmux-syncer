#!/usr/bin/env bash
# A script to catch and map exactly 0-9 to pane number if exist

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"


# honour pane-number-index
pane_id=$(tmux list-panes -F '#{pane_index} #{pane_id}' | awk -v n="$1" '$1==n{print $2}')
[ -n "$pane_id" ] && toggle_pane "$pane_id" && tmux select-pane -t "$pane_id" # unknown number -> no-op, stay in mode

rearm_syncer
