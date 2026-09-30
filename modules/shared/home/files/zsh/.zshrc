# -----------------------------
# User scripts + XDG local bin
# -----------------------------
export PATH="$HOME/.config/scripts:$HOME/.local/bin:$PATH"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Completions before the single compinit
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit
compinit -C

if [ -f /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  bindkey '^[[C' autosuggest-accept
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# -----------------------------
# History
# -----------------------------
HISTFILE=$HOME/.local/state/zsh/history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# -----------------------------
# FZF / Zoxide
# -----------------------------
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# -----------------------------
# Eza
# -----------------------------
alias ls='eza --group-directories-first --icons always'
alias ll='eza -lh --group-directories-first --icons always --git'
alias la='eza -lha --group-directories-first --icons always --git'

# -----------------------------
# Git & Github
# -----------------------------
alias gs='git status'
alias ga='git add --all'
alias gp='git push origin main'
alias gc='git commit -m'

alias vi="nvim"
alias vim="nvim"
alias zz="zed"

if [ -x /run/current-system/sw/bin/starship ]; then
  eval "$(/run/current-system/sw/bin/starship init zsh)"
elif command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

export PATH="$HOME/.opencode/bin:$HOME/.grok/bin:$PATH"

# -----------------------------
# Java — Nix sets JAVA_HOME. Fall back to the JDK linked by jdk.nix.
# -----------------------------
if [ -z "${JAVA_HOME:-}" ] && [ -d /Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home ]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home"
fi
[ -n "${JAVA_HOME:-}" ] && export PATH="$JAVA_HOME/bin:$PATH"

# -----------------------------
# XQuartz — Linux apps in lima display here
# -----------------------------
if [ -d /opt/X11/bin ]; then
  export PATH="/opt/X11/bin:$PATH"
fi
if [ -z "${DISPLAY:-}" ] && [ -S /tmp/.X11-unix/X0 ]; then
  export DISPLAY=:0
fi

# Re-allow the lima guest after XQuartz restarts (cookie + xhost reset).
lima-x11() {
  export PATH="/opt/X11/bin:$PATH"
  export DISPLAY=:0
  open -a XQuartz
  local i
  for i in {1..40}; do
    [ -S /tmp/.X11-unix/X0 ] && break
    sleep 0.15
  done
  xhost +192.168.5.15 >/dev/null 2>&1 || true
  local cookie
  cookie=$(xauth list 2>/dev/null | awk '/unix:0/{print $NF; exit}')
  if [ -n "$cookie" ] && command -v limactl >/dev/null; then
    limactl shell linux-desktop -- xauth add host.lima.internal:0 MIT-MAGIC-COOKIE-1 "$cookie" >/dev/null 2>&1 || true
  fi
  echo "XQuartz is ready for lima linux-desktop (DISPLAY=host.lima.internal:0)"
}
