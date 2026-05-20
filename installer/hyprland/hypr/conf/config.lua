-- 获取主机名
local function get_hostname_cmd()
  -- 1. 拦截 io.popen 本身被禁用或由于 fork 失败导致的崩溃
  local pcall_status, file = pcall(io.popen, "uname -n")

  if not pcall_status or not file then
    return nil, "io.popen 执行失败或被系统禁用"
  end
  -- 2. 读取流内容
  local output = file:read("*a")
  -- 3. 关闭流并获取退出状态 (Lua 5.2+ 支持返回状态，5.1 返回 true/nil)
  local close_status = file:close()
  -- 4. 校验命令是否真正执行成功（处理命令不存在或无权限的情况）
  -- 在 Lua 5.1 中 close_status 可能是 nil；在 5.2+ 中若命令失败 close_status 为 nil 或 false
  if (close_status == nil or close_status == false) and (not output or output == "") then
    return nil, "命令执行返回错误码"
  end
  -- 5. 清洗字符串（去掉末尾的换行符 \n 或 \r\n）
  if output then
    output = output:match("^%s*(.-)%s*$")
  end
  -- 6. 最终确保拿到的不是空字符串
  if output and output ~= "" then
    return output
  end
  return nil, "未获取到有效的输出内容"
end

-- 获取屏幕分辨率信息
local function get_display_resolution(hostname)
  if hostname == "carl-archlinux" then
    -- work pc
    return "4k"
  elseif hostname == "carl-x1mini-arch" then
    return "4k"
  else
    return "1080p"
  end
end

local M = {}
M.hostname = get_hostname_cmd()
M.display_resolution = get_display_resolution(M.hostname)
return M
