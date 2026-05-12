hl.on("hyprland.start", function()
  hl.exec_cmd("xrdb $HOME/.config/hypr/.Xresources")
  -- clipboard manager
  hl.exec_cmd("wl-paste --type text --watch ~/.config/hypr/scripts/cliphist_smart_watch.sh")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  hl.exec_cmd("mako")
  hl.exec_cmd("waybar")
  hl.exec_cmd("blueman-applet & nm-applet")
  hl.exec_cmd("fcitx5")

  -- run hyprland init script
  hl.exec_cmd("~/.config/hypr/scripts/hypr_init.sh")
end)
