#!/usr/bin/env bash
# This is a tpm plugin to synchronize selection of subset panes.

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/variables.sh"

sync_key=$(get_tmux_option "$syncer_sync_key_option" "$syncer_sync_key_default")

tmux unbind-key "$sync_key"
tmux bind-key "$sync_key" run-shell "$CURRENT_DIR/scripts/start.sh"

# Exit
tmux bind-key -T syncer Escape run-shell "$CURRENT_DIR/scripts/cancel.sh"
tmux bind-key -T syncer q      run-shell "$CURRENT_DIR/scripts/cancel.sh"
