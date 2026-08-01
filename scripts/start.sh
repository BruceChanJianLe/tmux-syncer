#!/usr/bin/env bash
# prefix + v: enter pane-selection mode

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

set_win_option "$syncer_selected_option" ""

PANE_BASE=$(tmux show-options -g pane-base-index | awk '{print $2}')

tmux display-message "syncer: ${PANE_BASE}-9 / hjkl + Space to pick, Enter to sync, q to quit"

# Enter pane selection mode
rearm_syncer
