# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-08-01

### Added
- Synchronize keyboard input to a chosen **subset** of panes. `prefix + v` opens
a visual selection overlay; pick panes with `0`-`9` or `hjkl` + `Space`, then
`Enter` (or `s`) to sync. Input is fanned to the selected panes only; the rest
keep running but ignore input (`select-pane -d`).
- `prefix + V` to unsync and re-enable input on every pane.
- `-` to toggle between the current and the last selection.
- Recall the last selection by pressing `Enter` with nothing selected.
- Configurable via `@syncer-sync-key`, `@syncer-unsync-key`, and
`@syncer-selected-style`.

### Experimental (not released)
- Grouping selected panes into a dedicated window (`group_panes.sh` /
        `ungroup_panes.sh`) — still under development, undocumented.

[1.0.0]: https://github.com/BruceChanJianLe/tmux-syncer/releases/tag/v1.0.0
