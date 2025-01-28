# Set Environment Variables
export PATH="/Users/maclong/.bun/bin:$PATH"
export EDITOR=hx

# Setup Completions
autoload -U compinit
compinit -i

# Aliases
alias c='clear'
alias g='git'
alias hg='history | grep'
alias mkdir='mkdir -p'

# Yazi Wrapper
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Make Directory and Navigate Into
mkcd() {
	mkdir -p "$1" && cd "$1" || return
}

# Setup CLI Tools
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
