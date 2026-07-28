#!/usr/bin/env bash
# Move focus during selection mode

CURRENT_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

# which keys are being pressed?
dir="$1"

# move to that pane
case "$dir" in
  L|R|D|U) tmux select-pane -"$dir" 2> /dev/null ;;
esac

# rearm
rearm_syncer
