# dotfiles

GNU Stow packages for an Omarchy Linux (Quattro / 4.x) system.

## Usage

```bash
stow --no-folding -d ~/Projects/dotfiles -t ~ hypr    # link
stow --no-folding -d ~/Projects/dotfiles -t ~ -D hypr # unlink
stow --no-folding -d ~/Projects/dotfiles -t ~ -R hypr # relink after adding files
```

`--no-folding` is required, not cosmetic. Without it Stow collapses
`~/.config/hypr` into a single symlink pointing at this repo, and every
`*.bak.<timestamp>` that Omarchy drops during an upgrade lands inside the repo
as untracked junk. With it, `~/.config/hypr` stays a real directory holding
per-file symlinks, and Omarchy's backups stay outside version control.

## Packages

### `hypr`

| File | Why it's tracked |
|------|------------------|
| `bindings.lua` | Scrolling-layout bindings: column focus/swap, width toggle, relative workspace switching, scratch workspace |
| `input.lua` | `caps:swapescape` + `compose:ralt`, `repeat_delay`, `follow_mouse = 0`, `cursor.no_warps` |
| `looknfeel.lua` | Scrolling layout, `rounding = 8`, column widths |
| `scripts/toggle_window_workspace.sh` | Bound to `SUPER+semicolon` |

## What is deliberately NOT tracked

Omarchy ships eight user config files in `/usr/share/omarchy/config/hypr/`.
Only files that have actually diverged from those defaults belong here.

- **`hyprland.lua`, `autostart.lua`** — byte-identical to the shipped defaults.
  Omarchy hashes these files on upgrade and treats "matches a known default" as
  permission to replace them with the new default. That replacement path
  (`copy_config_default`) does `rm -f "$target"` followed by `cp`, which
  *destroys a symlink* and leaves a real file behind. Tracking a stock file
  therefore guarantees a broken link on some future upgrade. Files that have
  diverged fail the hash check and are never touched.

  `hyprland.lua` is also the Lua loader — it gains `require` lines as Omarchy
  adds features, so leaving it on the auto-update track is what keeps new
  functionality wired up.

- **`monitors.lua`** — machine-specific. Holds only `omarchy_gdk_scale` and
  `omarchy_monitor_scale`, which change with the current display setup.

- **`hyprsunset.conf`, `xdph.conf`** — read by separate processes (`hyprsunset`,
  xdg-desktop-portal), not by Hyprland. Currently stock.

- **`.luarc.json`** — editor/LSP config, shipped by Omarchy.

## Notes

Omarchy's other write paths (`omarchy refresh config`, the update migrations)
use `cp` and `cat >`, which write *through* a symlink rather than replacing it.
So an upgrade that modifies a tracked file shows up here as a plain `git diff`
rather than a broken link. That is the intended failure mode — review the diff,
keep or revert.

Empty-looking override files are not deletable: `hyprland.lua` loads them with
`require("hypr.looknfeel")` and friends, and the module path resolves only to
`~/.config/hypr/`, with no fallback to the packaged copy. Deleting one is a hard
config error.
