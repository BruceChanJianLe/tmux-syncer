#!/usr/bin/env bash
# syncer table, esc / q, leave selection mode without syncing

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

revert_selection

tmux display-message "syncer: cancelled"
