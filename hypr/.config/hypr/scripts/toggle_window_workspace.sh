#!/usr/bin/env bash

special_name="scratch"
special_ws="special:$special_name"

# Hyprland's Lua config provider evaluates `hyprctl dispatch` arguments as Lua,
# so the classic `hyprctl dispatch <dispatcher> <args>` form no longer parses.
# Dispatches must be hl.dsp.* expressions.
move_to_workspace_silent() {
    hyprctl dispatch "hl.dsp.window.move({ workspace = \"$1\", follow = false })"
}

toggle_special_workspace() {
    hyprctl dispatch "hl.dsp.workspace.toggle_special(\"$1\")"
}

win_ws="$(hyprctl -j activewindow | jq -r '.workspace.name')"
regular_ws="$(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | .activeWorkspace.name')"

if [[ "$win_ws" == "$special_ws" ]]; then
    move_to_workspace_silent "$regular_ws"

    remaining="$(
        hyprctl -j clients |
        jq --arg ws "$special_ws" '[.[] | select(.workspace.name == $ws)] | length'
    )"

    if [[ "$remaining" == "0" ]]; then
        toggle_special_workspace "$special_name"
    fi
else
    move_to_workspace_silent "$special_ws"
fi
