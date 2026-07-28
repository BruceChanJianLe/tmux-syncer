#!/usr/bin/env bash
# A script to catch and map exactly 0-9 to pane number if exist

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

echo "[$(date '+%H:%M:%S')] FIRED arg='$1' win=$(tmux display-message -p '#{window_id}')" >> /tmp/syncer_debug.log

# honour pane-number-index
pane_id=$(tmux list-panes -F '#{pane_index} #{pane_id}' | awk -v n="$1" '$1==n{print $2}')
echo "    mapped='$pane_id' panes=[$(tmux list-panes -F '#{pane_index}=#{pane_id}' | tr '\n' ' ')] selected=[$(get_win_option "$syncer_selected_option")]" >> /tmp/syncer_debug.log
[ -n "$pane_id" ] && toggle_pane "$pane_id" && tmux select-pane -t "$pane_id" # unknown number -> no-op, stay in mode

rearm_syncer
