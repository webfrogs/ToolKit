hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "make file picker float",
  match = {
    class = "^com.gabm.satty$",
  },
  float = true,
})

hl.window_rule({
  name = "pin chrome to worksapce 2",
  match = {
    class = "^google-chrome$"
  },
  workspace = 2,
})

hl.window_rule({
  name = "pin thunderbird to worksapce 4",
  match = {
    class = "^org.mozilla.Thunderbird$",
  },
  workspace = 4,
})

hl.window_rule({
  name = "1password",
  match = {
    class = "^1password$"
  },
  float = true,
  size = { 640, 480 },
  group = "barred",
})

hl.window_rule({
  name = "fix_tg_fullscreen",
  match = {
    class = "^org.telegram.desktop$"
  },
  fullscreen = false,
  fullscreen_state = "0"
})

-- 文件选择窗口
hl.window_rule({
  name = "fix_file_picker_window",
  match = {
    title = "^Open Files?$"
  },
  float = true,
  max_size = { 2000, 1000 },
  no_blur = true,
  no_shadow = true,
  border_size = 0,
})

-- 腾讯会议
hl.window_rule({
  name = "pin wemeet to workspace 3",
  match = {
    class = "^wemeetapp$"
  },
  workspace = 3,
  float = true,
})

-- 解决微信弹窗显示问题
hl.window_rule({
  name = "wechat_rule_1",
  match = {
    class = "wechat",
    title = "negative:^(朋友圈|微信|设置|聊天文件|预览|图片和视频)\\W*",
  },
  no_blur = true,
  no_shadow = true,
  border_size = 0,
})
hl.window_rule({
  name = "wechat_rule_2",
  match = {
    class = "wechat",
    title = "^微信发送给$",
  },
  no_blur = true,
  no_shadow = true,
  border_size = 0,
})

-- 飞书会议
hl.window_rule({
  name = "feishu_meeting",
  match = {
    title = "^飞书会议$"
  },
  workspace = 3,
  focus_on_activate = false,
  no_initial_focus = true
})
