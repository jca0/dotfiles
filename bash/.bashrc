export PATH="$HOME/.local/bin:$PATH"

# aliases
alias clauded='claude --dangerously-skip-permissions'
alias codey='codex --yolo'

# activate nearest .venv (walks up from cwd)
va() {
  local d="$PWD"
  while [[ "$d" != "/" ]]; do
    [[ -f "$d/.venv/bin/activate" ]] && source "$d/.venv/bin/activate" && return
    d="$(dirname "$d")"
  done
  echo "no .venv found" >&2; return 1
}
