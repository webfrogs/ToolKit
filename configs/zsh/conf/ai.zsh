ai_commit() {
  # agy --dangerously-skip-permissions --model "Gemini 3.5 Flash (Medium)" -p "current folder is workspace, make git commit"
  local models model
  models=$(opencode models 2>/dev/null | grep -i free)
  model=$(<<<"$models" grep -i deepseek | head -1)
  [[ -z "$model" ]] && model=$(<<<"$models" head -1)
  print "Using model: $model"
  opencode run --dangerously-skip-permissions -m "$model" 'create a new git commit'
}
