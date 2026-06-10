tmux_project() {
  local session_name

  session_name="${PWD:t}"

  if tmux has-session -t "=${session_name}" 2>/dev/null; then
    if [[ -n "${TMUX}" ]]; then
      tmux switch-client -t "=${session_name}"
    else
      tmux attach-session -t "=${session_name}"
    fi
    return
  fi

  if [[ -n "${TMUX}" ]]; then
    tmux new-session -d -s "${session_name}"
    tmux switch-client -t "=${session_name}"
  else
    tmux new-session -s "${session_name}"
  fi
}
