# dotfiles

GNU Stow packages for an Omarchy Linux (Quattro / 4.x) system.

## Usage

Run these from the repo root — `.stowrc` supplies `--dir`, `--target` and
`--no-folding`, and Stow only reads it from the current directory.

```bash
cd ~/Projects/dotfiles
stow hypr      # link
stow -D hypr   # unlink
stow -R hypr   # relink, e.g. after adding files to a package
stow */        # link every package
```

`--no-folding` is required, not cosmetic, which is why `.stowrc` pins it.
Without it Stow collapses `~/.config/hypr` into a single symlink pointing at
this repo, and every `*.bak.<timestamp>` that Omarchy drops during an upgrade
lands inside the repo as untracked junk. With it, `~/.config/hypr` stays a real
directory holding per-file symlinks, and Omarchy's backups stay outside version
control.

Use `stow --adopt <package>` only when the live files are already known to be
byte-identical to the package copies; it overwrites package contents with
whatever is in the target.

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
