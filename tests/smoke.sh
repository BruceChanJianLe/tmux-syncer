#!/usr/bin/env bash
#
# Smoke test for tmux-syncer.
#
# Loads the plugin into a headless tmux server and checks that:
#   1. every script parses (bash -n),
#   2. the `syncer` key-table bindings are actually created,
#   3. the sync backend works: selecting >=2 panes + commit turns
#      synchronize-panes ON, and unsync turns it OFF again.
#
# The interactive overlay (display-panes / switch-client) needs an attached
# client, which CI doesn't have, so we drive the backend directly by setting
# @syncer-selected and running commit.sh / unsync.sh — no keystrokes needed.
#
# Run locally:  bash tests/smoke.sh
set -eu

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
pass() { printf '  ok   %s\n' "$1"; }
fail() { printf '  FAIL %s\n' "$1"; exit 1; }

command -v tmux >/dev/null || { echo "tmux not installed"; exit 1; }

# Use a throwaway server on its own socket so we never touch a real session.
SOCKET="syncer-smoke-$$"
TMUX_CMD=(tmux -L "$SOCKET")
cleanup() { "${TMUX_CMD[@]}" kill-server 2>/dev/null || true; }
trap cleanup EXIT

echo "== syntax =="
for f in "$ROOT"/syncer.tmux "$ROOT"/scripts/*.sh; do
  bash -n "$f" && pass "parse $(basename "$f")" || fail "parse $(basename "$f")"
done

echo "== start server + 3 panes =="
"${TMUX_CMD[@]}" new-session -d -x 200 -y 50
"${TMUX_CMD[@]}" split-window -h
"${TMUX_CMD[@]}" split-window -v
"${TMUX_CMD[@]}" select-layout tiled
n=$("${TMUX_CMD[@]}" list-panes | wc -l)
[ "$n" -eq 3 ] && pass "3 panes created" || fail "expected 3 panes, got $n"

echo "== load plugin =="
# Run syncer.tmux via `run-shell` so the bare `tmux` calls inside it inherit
# $TMUX and wire the bindings into THIS throwaway server.
"${TMUX_CMD[@]}" run-shell "bash $ROOT/syncer.tmux"

echo "== key-table wired up =="
keys=$("${TMUX_CMD[@]}" list-keys -T syncer 2>/dev/null || true)
for key in 1 2 3 h j k l Space Enter q; do
  printf '%s\n' "$keys" | grep -qE "[[:space:]]${key}[[:space:]]" \
    && pass "binding '$key'" || fail "syncer table missing binding for '$key'"
done

echo "== referenced scripts exist =="
for s in start toggle_index toggle_cursor move commit cancel unsync recall; do
  [ -f "$ROOT/scripts/$s.sh" ] && pass "scripts/$s.sh" || fail "scripts/$s.sh missing"
done

echo "== sync backend toggles synchronize-panes =="
# Pick the first two panes as the selection.
ids=$("${TMUX_CMD[@]}" list-panes -F '#{pane_id}')
# shellcheck disable=SC2086
set -- $ids
"${TMUX_CMD[@]}" set-option -w @syncer-selected "$1 $2"

"${TMUX_CMD[@]}" run-shell "$ROOT/scripts/commit.sh"; sleep 0.3
sync=$("${TMUX_CMD[@]}" show-options -wv synchronize-panes 2>/dev/null || echo "")
[ "$sync" = "on" ] && pass "synchronize-panes on after commit" \
  || fail "expected synchronize-panes 'on' after commit, got '$sync'"

"${TMUX_CMD[@]}" run-shell "$ROOT/scripts/unsync.sh"; sleep 0.3
sync=$("${TMUX_CMD[@]}" show-options -wv synchronize-panes 2>/dev/null || echo "off")
[ "$sync" = "off" ] && pass "synchronize-panes off after unsync" \
  || fail "expected synchronize-panes 'off' after unsync, got '$sync'"

echo "ALL SMOKE TESTS PASSED"
