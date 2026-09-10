#!/bin/bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "[ERROR] Only Linux is supported." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "[ERROR] Please install jq before running this script." >&2
  exit 1
fi

sudo_cmd=()
if [[ "$EUID" -ne 0 ]]; then
  sudo_cmd=(sudo)
fi

daemon_config=/etc/docker/daemon.json
temp_config=$(mktemp)
trap 'rm -f "$temp_config"' EXIT

if "${sudo_cmd[@]}" test -e "$daemon_config"; then
  "${sudo_cmd[@]}" cat "$daemon_config" > "$temp_config"
else
  echo '{}' > "$temp_config"
fi

# Reject malformed JSON, non-object values and multiple JSON documents.
if ! jq -e -s 'length == 1 and (.[0] | type == "object")' "$temp_config" >/dev/null; then
  echo "[ERROR] $daemon_config must contain a valid JSON object." >&2
  exit 1
fi

if jq -e '.ipv6 == true' "$temp_config" >/dev/null; then
  echo "[INFO] Docker IPv6 is already enabled."
  exit 0
fi

# Keep an existing subnet; otherwise use a private IPv6 subnet for the bridge.
config=$(jq '.ipv6 = true | .["fixed-cidr-v6"] //= "fd42:8b6e:3c91::/64"' "$temp_config")
printf '%s\n' "$config" > "$temp_config"

"${sudo_cmd[@]}" mkdir -p /etc/docker
"${sudo_cmd[@]}" tee "$daemon_config" < "$temp_config" >/dev/null
"${sudo_cmd[@]}" systemctl restart docker
echo "[INFO] Docker IPv6 is enabled and the Docker service has been restarted."
