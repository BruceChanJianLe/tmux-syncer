#!/usr/bin/env bash
# To select and unselect in selection mode

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

# add to id list
# update selected / unselected pane style
pane_id=$(tmux display-message -p '#{pane_id}')
toggle_pane "$pane_id"

# rearm
rearm_syncer
