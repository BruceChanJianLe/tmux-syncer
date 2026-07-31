#!/usr/bin/env bash
# To ungroup selected panes and bring back from hidden window

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

# Defensive move
revert_selection

origin=$(tmux display-message -p '#{window_id}')
hold=$(get_win_option "$syncer_active_option" "")

# Join panes from void into this window (last to join closes the hidden window)
if [ -n "$hold" ] && tmux list-windows -a -F '#{window_id}' | grep -qx "$hold"; then
  for id in $(tmux list-panes -t "$hold" -F '#{pane_id}'); do
    tmux join-pane -d -s "$id" -t "$origin"
  done
  # Restore the ungroup layout (falls back to tiled if cannot be reapplied)
  restore_layout "$origin" "$(get_win_option "$syncer_original_layout_option" "")"
fi

# Reset vars
unset_win_option "$syncer_active_option"
unset_win_option "$syncer_origin_option"
unset_win_option "$syncer_original_layout_option"

tmux display-message "syncer: ungroup"
