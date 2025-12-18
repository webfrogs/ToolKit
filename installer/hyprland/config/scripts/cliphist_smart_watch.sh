#!/bin/sh
set -e

BLACKLIST=(
  "1password"
)

# 将黑名单转为小写便于比较
for i in "${!BLACKLIST[@]}"; do
  BLACKLIST[i]=$(echo "${BLACKLIST[i]}" | tr '[:upper:]' '[:lower:]')
done

clipcontent=$(cat)

# 获取当前活跃窗口的 class（应用标识）
ACTIVE_CLASS=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty' 2>/dev/null)

if [ -n "$ACTIVE_CLASS" ]; then
  ACTIVE_LOW=$(echo "$ACTIVE_CLASS" | tr '[:upper:]' '[:lower:]')

  # 检查是否在黑名单中
  SKIP=false
  for banned in "${BLACKLIST[@]}"; do
    if [[ "$ACTIVE_LOW" == "$banned" ]]; then
      SKIP=true
      break
    fi
  done

  if [ "$SKIP" = true ]; then
    exit 0
  fi
fi

# 存入 cliphist
printf "%s" "$clipcontent" | cliphist store
