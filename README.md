# dotfiles

GNU Stow packages for an Omarchy Linux (Quattro / 4.x) system.

## Setup

This repo is public. A pre-commit hook in `.githooks/` runs `gitleaks` on
staged changes and refuses the commit if it finds a secret or if `gitleaks` is
missing. Git does not run hooks from a clone automatically; enable it once per
clone:

```bash
omarchy pkg add gitleaks
git config core.hooksPath .githooks
```

## Usage

Run these from the repo root — `.stowrc` supplies `--dir`, `--target` and
`--no-folding`, and Stow only reads it from the current directory.

```bash
cd ~/Projects/dotfiles
stow hypr      # link
stow -D hypr   # unlink
stow -R hypr   # relink, e.g. after adding, removing or renaming files
stow */        # link every package
```

`--no-folding` is required, not cosmetic, which is why `.stowrc` pins it.
Without it Stow collapses `~/.config/hypr` into a single symlink pointing at
this repo, and every `*.bak.<timestamp>` that Omarchy drops during an upgrade
lands inside the repo as untracked junk. With it, `~/.config/hypr` stays a real
directory holding per-file symlinks, and Omarchy's backups stay outside version
control.

Because links are per file, deleting or renaming a file here leaves a dangling
symlink in `~/.config/hypr` until you run `stow -R`.

Use `stow --adopt <package>` only when the live files are already known to be
byte-identical to the package copies; it overwrites package contents with
whatever is in the target.

## Packages

### `hypr`

| File | Why it's tracked |
|------|------------------|
| `hyprland.lua` | Omarchy's loader plus `require("hypr.windows")`, so a fresh checkout loads `windows.lua` |
| `bindings.lua` | Scrolling-layout bindings: column focus/swap, width toggle, relative workspace switching, the `scratch` special workspace |
| `input.lua` | `caps:swapescape` + `compose:ralt`, `repeat_delay`, `follow_mouse = 0`, `focus_on_close = 2`, `cursor.no_warps` |
| `looknfeel.lua` | Scrolling layout, `rounding = 8`, column widths |
| `windows.lua` | Tiles Omarchy's `floating-window` apps and omacalc into the scroll at half width |
| `scripts/toggle_scratch_window.sh` | Bound to `SUPER+semicolon`: moves the active window into or out of `scratch` |

`hyprland.lua` is the one tracked file that is otherwise stock, and tracking it
has a cost. Omarchy's migrations recognise an untouched config file by its
`sha256sum` and update it to the new default; this copy no longer matches, so
`require` lines Omarchy adds to the stock loader for new features will not
arrive on their own. After an Omarchy upgrade, compare and merge by hand:

```bash
diff /usr/share/omarchy/config/hypr/hyprland.lua hypr/.config/hypr/hyprland.lua
```

## What is deliberately NOT tracked

Omarchy ships eight user config files in `/usr/share/omarchy/config/hypr/`.
Only files that have actually diverged from those defaults belong here.

- **`autostart.lua`** — byte-identical to the shipped default. Left as a real
  file, it stays on Omarchy's update path; tracked, every upgrade to it would
  land here as a diff to review.

- **`monitors.lua`** — machine-specific. Holds only `omarchy_gdk_scale` and
  `omarchy_monitor_scale`, which change with the current display setup.

- **`hyprsunset.conf`, `xdph.conf`** — read by separate processes (`hyprsunset`,
  xdg-desktop-portal), not by Hyprland. Currently stock.

- **`.luarc.json`** — editor/LSP config, shipped by Omarchy.

## Notes

Omarchy's update migrations edit config files with `cp` and `cat >>`, which
write *through* a symlink rather than replacing it. So an upgrade that modifies
a tracked file shows up here as a plain `git diff` rather than a broken link.
That is the intended failure mode — review the diff, keep or revert.

Empty-looking override files are not deletable: `hyprland.lua` loads them with
`require("hypr.looknfeel")` and friends, and the module path resolves only to
`~/.config/hypr/`, with no fallback to the packaged copy. Deleting one is a hard
config error.
