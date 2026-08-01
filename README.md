> Synchronize keyboard input to a subset of panes in a tmux window.

![demo](https://github.com/user-attachments/assets/43589d8b-935e-4631-870e-0541c46aefa8)

> Pick the panes you want from a quick visual overlay, press `s` or `Enter`, and
> whatever you type in one of them is sent to all of them. The panes you didn't
> pick keep running untouched.

## How it works

tmux's `synchronize-panes` is a *window-level* switch — it fans input to every
pane. tmux-syncer turns it on for the window but **disables input on the panes
you didn't select** (`select-pane -d`), so the synchronized keystrokes only reach
your chosen panes. Nothing is moved and no process is stopped — the unselected
panes simply ignore input until you unsync.

## Requirements

- tmux 3.x or newer (uses `display-panes -N`, `select-pane -d`, per-pane styles).

## Installation

With [TPM](https://github.com/tmux-plugins/tpm), add to `~/.tmux.conf`:

```tmux
set -g @plugin 'BruceChanJianLe/tmux-syncer'
```

Then press `prefix + I` to install.

**Manual:** clone the repo and add to `~/.tmux.conf`:

```tmux
run-shell ~/.config/tmux/plugins/tmux-syncer/syncer.tmux
```

## Usage

| Key | Action |
| --- | --- |
| `prefix + v` | Enter selection mode; selected panes are greyed out (the greyed-out effect may not be visible depending on what a pane is running, e.g. nvim) |
| `prefix + V` | Unsync and re-enable all panes |
| `0`-`9` | Toggle the pane with that number |
| `h` `j` `k` `l` / arrows | Move the cursor (active pane) |
| `Space` | Toggle the pane under the cursor |
| `-` | Toggle between your current and last selection |
| `s` / `Enter` | Sync the selected panes (requires at least 2) |
| `q` / `Esc` | Cancel and leave selection mode |

> Pro Tip: Entering selection mode and pressing `s` or `Enter` without picking
> anything re-syncs your **last** selection.

## Custom Configuration

Add any of these to `~/.tmux.conf` or `$XDG_CONFIG_HOME/tmux/tmux.conf`
before the plugin is loaded:

```tmux
# Key (off the prefix) that enters selection mode. Default: v
set -g @syncer-sync-key 'v'

# Key (off the prefix) that unsyncs. Default: V
set -g @syncer-unsync-key 'V'

# Style applied to a selected (greyed-out) pane. Default: bg=colour236,fg=colour245
set -g @syncer-selected-style 'bg=colour236,fg=colour245'
```

## Story Behind

As a software engineer doing ad-hoc testing, I often find myself needing to
synchronize just a handful of panes while leaving the others untouched. tmux can
only synchronize a whole window, so there was no clean way to sync a subset.

After much digging I found plenty of folks who share this same pain point online,
but no plugin that really addressed it, which is what inspired tmux-syncer.

**Others with the same pain point:**
- Stack Overflow: https://stackoverflow.com/questions/12451951/tmux-synchronize-some-but-not-all-panes
- Super User: https://superuser.com/questions/1815263/synchronize-and-desync-only-some-panes-in-tmux-with-one-command

## License

MIT
