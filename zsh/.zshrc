autoload -Uz compinit && compinit

export PATH="$HOME/.local/bin:$PATH"

# aliases
alias clauded='claude --dangerously-skip-permissions'
alias codey='codex --yolo'

eval "$(zoxide init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jing/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jing/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jing/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jing/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# opencode
export PATH=/Users/jing/.opencode/bin:$PATH

# CoJudge CLI
alias cojudge='node /Users/jing/Desktop/cojudge/bin/cojudge'

# activate nearest .venv (walks up from cwd)
va() {
  local d="$PWD"
  while [[ "$d" != "/" ]]; do
    [[ -f "$d/.venv/bin/activate" ]] && source "$d/.venv/bin/activate" && return
    d="$(dirname "$d")"
  done
  echo "no .venv found" >&2; return 1
}
