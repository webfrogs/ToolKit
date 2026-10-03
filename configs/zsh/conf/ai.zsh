ai_commit() {
  # agy --dangerously-skip-permissions --model "Gemini 3.5 Flash (Medium)" -p "current folder is workspace, make git commit"
  opencode run --dangerously-skip-permissions -m 'deepseek/deepseek-flash' 'create a new git commit'
}
