ai_commit() {
  # agy --dangerously-skip-permissions --model "Gemini 3.5 Flash (Medium)" -p "current folder is workspace, make git commit"
  opencode run --dangerously-skip-permissions -m 'deepseek/deepseek-v4-flash' 'make git commit'
}
