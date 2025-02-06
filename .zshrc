export EDITOR=hx

# Setup Completions
autoload -U compinit
compinit -i

# Aliases
alias g='git'
alias hg='history | grep'
alias mkdir='mkdir -p'

# Run in Background
rib() {
	nohup $1 >/dev/null 2>&1 &
}

# Kill Port
kp() { 
	kill -9 $(lsof -ti tcp:$1); 
}

# Yazi Wrapper
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Setup CLI Tools
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
