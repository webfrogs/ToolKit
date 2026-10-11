hl.on("hyprland.start", function()
  -- clipboard manager
  hl.exec_cmd("wl-paste --type text --watch ~/.config/hypr/scripts/cliphist_smart_watch.sh")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  hl.exec_cmd("mako")
  hl.exec_cmd("waybar")
  hl.exec_cmd("blueman-applet & nm-applet")
  hl.exec_cmd("fcitx5")

  hl.exec_cmd("thunderbird", { workspace = "4", no_initial_focus = true })
  hl.exec_cmd("sleep 1 && kitty", { workspace = "1", group = "set" })
  hl.exec_cmd("sleep 1 && hyprctl reload") -- 解决飞书等app窗口无法正确缩放问题
end)
