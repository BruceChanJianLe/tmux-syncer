#!/usr/bin/env bash
# use '-' dash to toggle between last selected group

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

curr=$(get_win_option "$syncer_selected_option" "")
prev=$(get_win_option "$syncer_last_option" "")

# Nothing to toggle if no history
if [ -z "$prev" && -z "$curr"]; then
  rearm_syncer
  exit 0
fi

# Swap if last exist
set_win_option "$syncer_selected_option" "$prev"
set_win_option "$syncer_last_option"     "$curr"

# Dim the selected group
dim=$(get_tmux_option "$syncer_selected_style_option" "$syncer_selected_style_default")
for id in $(tmux list-panes -F '#{pane_id}'); do
  if list_contains "$prev" "$id"; then
    tmux set-option -p  -t "$id" window-style "$dim" 2> /dev/null
  else
    tmux set-option -pu -t "$id" window-style       2> /dev/null
  fi
done

rearm_syncer
