hl.monitor({
  output = "eDP-1",
  mode = "1600x2560@144",
  position = "0x0",
  scale = "2",
  transform = 1,
})
hl.monitor({
  output = "DP-1",
  mode = "1920x1080@60",
  position = "1280x0",
  scale = "1",
})
hl.on("hyprland.start", function()
  hl.config({
    input = {
      touchdevice = {
        transform = 1,
      }
    }
  })
end)
