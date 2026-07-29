#!/usr/bin/env bash
# To unsync selected panes

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

# disable sync
tmux set-option -w synchronize-panes off

# enable all panes
for id in $(tmux list-panes -F '#{pane_id}'); do
  tmux select-pane -t "$id" -e
done
