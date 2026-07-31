#!/usr/bin/env bash
# Shallow any other keys, warn and rearm

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

tmux display-message "syncer: unregconized key, use q or esc to quit."

rearm_syncer
