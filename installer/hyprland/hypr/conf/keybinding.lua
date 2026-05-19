local mainMod     = "ALT"
---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "fuzzel"

-- doc: https://wiki.hypr.land/Configuring/Basics/Binds/

-- disable fcitx5 spell shortcut
hl.bind(mainMod .. " + CTRL + H", hl.dsp.exec_cmd("true"))

-- toggle display enable
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.dpms())

-- launch apps
-- hl.bind(mainMod .. " + ", hl.dsp.exec_cmd(""))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --with-nth 2 | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("1password"))

-- # screenshot
hl.bind(mainMod .. " + CTRL + S",
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
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("hyprlock"))

-- # hyprland group
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))

-- # control window
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SPACE", function()
  local curWindow = hl.get_active_window()
  if not curWindow then
    return
  end
  if curWindow.floating then
    hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
  else
    hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
  end
end)
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float())

hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move { direction = "r" })
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.move { direction = "u" })
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move { direction = "d" })
local arrowKeys = { "Left", "Right", "Up", "Down" }
local vimDirKeys = { "H", "L", "K", "J", }
local hlDirList = { "l", "r", "u", "d" }
for i = 1, 4 do
  local vimDir = vimDirKeys[i]
  local arrow = arrowKeys[i]
  local hlDir = hlDirList[i]
  local focusFunc = function()
    local curWindow = hl.get_active_window()
    if not curWindow then
      return
    end
    local curGroup = curWindow.group
    if curGroup then
      -- active window in group
      if i == 1 and curGroup.current_index > 1 then -- left
        hl.dispatch(hl.dsp.group.prev())
        return
      end
      if i == 2 and curGroup.current_index < curGroup.size then -- right
        hl.dispatch(hl.dsp.group.next())
        return
      end
      hl.dispatch(hl.dsp.focus({ direction = hlDir }))
    else
      hl.dispatch(hl.dsp.focus({ direction = hlDir }))
    end
  end
  hl.bind(mainMod .. " + " .. vimDir, focusFunc, { repeating = true })

  local moveFunc = function()
    local curWindow = hl.get_active_window()
    if not curWindow then
      return
    end
    local curGroup = curWindow.group
    if curGroup then
      if i == 1 and curGroup.current_index > 1 then
        hl.dispatch(hl.dsp.group.move_window({ forward = false }))
      elseif i == 2 and curGroup.current_index < curGroup.size then
        hl.dispatch(hl.dsp.group.move_window({ forward = true }))
      else
        hl.dispatch(hl.dsp.window.move({ direction = hlDir }))
      end
    end
  end
  hl.bind(mainMod .. " + SHIFT + " .. vimDir, moveFunc)

  hl.bind(mainMod .. " + " .. arrow, hl.dsp.window.move({ into_group = hlDir }))
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

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
