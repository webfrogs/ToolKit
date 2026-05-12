local mainMod     = "ALT"
---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "fuzzel"

-- doc: https://wiki.hypr.land/Configuring/Basics/Binds/
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))


-- disable fcitx5 spell shortcut
hl.bind(mainMod .. " + Control_L + H", hl.dsp.exec_cmd("true"))

-- toggle display enable
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("hyprctl dispatch dpms toggle"))

-- launch apps
-- hl.bind(mainMod .. " + ", hl.dsp.exec_cmd(""))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --with-nth 2 | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("1password"))

-- # screenshot
hl.bind(mainMod .. " + Control_L + S",
  hl.dsp.exec_cmd(
    'grim -g "$(slurp -b 1B1F28CC -c E06B74ff -s C778DD0D -w 2)" - | GTK_IM_MODULE=fcitx satty --filename - --output-filename ~/Pictures/Screenshots/Screenshot_$(date +"%Y-%m-%d-%s").png --init-tool line --copy-command wl-copy --font-family "LXGW WenKai Mono"'))
hl.bind(mainMod .. " + SHIFT + S",
  hl.dsp.exec_cmd(
    'grim - | GTK_IM_MODULE=fcitx satty --filename - --output-filename ~/Pictures/Screenshots/Screenshot_screen_$(date +"%Y-%m-%d-%s").png --init-tool line --copy-command wl-copy --font-family "LXGW WenKai Mono"'))

-- control media
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("playerctl play-pause"))

-- # hyprland features
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("~/.config/hypr/scripts/hypr_exit.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("pkill waybar || true && waybar"))
hl.bind(mainMod .. " + Control_L + Q", hl.dsp.exec_cmd("hyprlock"))

-- # hyprland group
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.group.next())

-- # control window
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/hypr_focus_floating_toggle.sh"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + Left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + Right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + Up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + Down", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.move({ into_or_create_group = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move { into_or_create_group = "r" })
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.move { into_or_create_group = "u" })
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move { into_or_create_group = "d" })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
