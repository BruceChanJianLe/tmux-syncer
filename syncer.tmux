#!/usr/bin/env bash
# This is a tpm plugin to synchronize selection of subset panes.

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/variables.sh"

sync_key=$(get_tmux_option   "$syncer_sync_key_option"   "$syncer_sync_key_default")
unsync_key=$(get_tmux_option "$syncer_unsync_key_option" "$syncer_unsync_key_default")
# Not used at the moment
group_key=$(get_tmux_option   "$syncer_group_key_option"   "$syncer_group_key_default")
ungroup_key=$(get_tmux_option "$syncer_ungroup_key_option" "$syncer_ungroup_key_default")

# Enter selection mode
tmux unbind-key "$sync_key"
tmux bind-key "$sync_key" run-shell "$CURRENT_DIR/scripts/start.sh"

# Unsync
tmux unbind-key "$unsync_key"
tmux bind-key "$unsync_key" run-shell "$CURRENT_DIR/scripts/unsync.sh"

# Exit selection mode
tmux bind-key -T syncer Escape run-shell "$CURRENT_DIR/scripts/cancel.sh"
tmux bind-key -T syncer q      run-shell "$CURRENT_DIR/scripts/cancel.sh"

# Hotkeys
for n in 0 1 2 3 4 5 6 7 8 9; do
  tmux bind-key -T syncer "$n" run-shell "$CURRENT_DIR/scripts/toggle_index.sh $n"
done

# Move focus
tmux bind-key -T syncer h     run-shell "$CURRENT_DIR/scripts/move.sh L"
tmux bind-key -T syncer j     run-shell "$CURRENT_DIR/scripts/move.sh D"
tmux bind-key -T syncer k     run-shell "$CURRENT_DIR/scripts/move.sh U"
tmux bind-key -T syncer l     run-shell "$CURRENT_DIR/scripts/move.sh R"
tmux bind-key -T syncer Left  run-shell "$CURRENT_DIR/scripts/move.sh L"
tmux bind-key -T syncer Down  run-shell "$CURRENT_DIR/scripts/move.sh D"
tmux bind-key -T syncer Up    run-shell "$CURRENT_DIR/scripts/move.sh U"
tmux bind-key -T syncer Right run-shell "$CURRENT_DIR/scripts/move.sh R"

# Select / Unselect pane
tmux bind-key -T syncer Space run-shell "$CURRENT_DIR/scripts/toggle_cursor.sh"

# Start Sync
tmux bind-key -T syncer Enter run-shell "$CURRENT_DIR/scripts/commit.sh"
tmux bind-key -T syncer s run-shell "$CURRENT_DIR/scripts/commit.sh"

# Create new group
tmux bind-key -T syncer c run-shell "$CURRENT_DIR/scripts/group_panes.sh"
# Ungroup
tmux bind-key "$ungroup_key" run-shell "$CURRENT_DIR/scripts/ungroup_panes.sh"
