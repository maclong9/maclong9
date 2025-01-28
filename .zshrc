# Set Editor
export EDITOR=/opt/homebrew/bin/hx

# Setup Completions
autoload -U compinit
compinit -i

# Aliases
alias c='clear'
alias g='git'
alias hg='history | grep'
alias mkdir='mkdir -p'

# Kill Ports
kp() {
	for port in "$@"; do
		pid=$(netstat -tlpn 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1)
		if [ -n "$pid" ]; then
			kill -9 "$pid" && echo "Killed process(es) on port $port"
		else
			echo "No process found on port $port"
		fi
	done
}

# Yazi Wrapper
function y() {
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

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="/Users/maclong/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
