#!/bin/sh
# macOS Development Environment Setup Script
# Downloads configuration files and sets up development environment with necessary tooling
# Usage: source <(curl -sSL https://raw.githubusercontent.com/maclong9/dots/refs/heads/main/setup.sh)

# Prompt for sudo password at the start
get_sudo_password() {
	printf "\033[1;34m→\033[0m \033[1;37mEnter your sudo password:\033[0m "
	read -r -s SUDO_PASSWORD
	echo
}

# Function to run sudo commands with the stored password
run_sudo() {
	local cmd="$1"
	echo "$SUDO_PASSWORD" | sudo -S $cmd
}

# Spinner function with new frames
spinner() {
	local pid=$1
	local delay=0.1
	local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
	local i=0
	printf "\033[?25l"  # Hide cursor
	while [ "$(ps a | awk '{print $1}' | grep "$pid")" ]; do
		printf "\033[1;33m%s\033[0m " "${frames[$i]}"  # Add space after spinner
		i=$(( (i+1) % ${#frames[@]} ))
		sleep $delay
		printf "\b\b"  # Move back two spaces to overwrite the spinner and space
	done
	printf "\033[?25h"  # Show cursor
	printf " \b"
}

# Run command with spinner
run_with_spinner() {
	local cmd="$1"
	local msg="$2"
	printf "\033[1;34m→\033[0m \033[1;37m%s\033[0m " "$msg"  # Add space after the message
	$cmd >/dev/null 2>&1 &
	spinner $!
	if [ $? -eq 0 ]; then
		printf "\033[1;32m✔\033[0m\n"  # Add space before checkmark
	else
		printf "\033[1;31m✗\033[0m\n"  # Add space before cross
		$cmd
		exit 1
	fi
}

# Cleanup function to restore system state on non-zero exit
trap 'cleanup' EXIT
cleanup() {
	if [ $? -ne 0 ]; then
		printf "\033[1;31m✗\033[0m \033[1;37mSetup failed, restoring system state\033[0m\n"
		cd "$HOME" || exit
		run_sudo "rm -rf .config .gitconfig .gitignore .vim .vimrc .zshrc /etc/pam.d/sudo_local"
		(crontab -l 2>/dev/null | sed '$d;$d;$d') | crontab -
		exit 1
	fi
}

# Get sudo password at the start
get_sudo_password

# Clone and symlink configuration files
run_with_spinner "git clone https://github.com/maclong9/dots .config" "Cloning configuration files"
for file in .config/.*; do
	case "$(basename "$file")" in
	"." | ".." | ".git") continue ;;
	*) ln -sf "$file" "${HOME}/$(basename "$file")" ;;
	esac
done

# macOS specific setup
if [ "$(uname -s)" = "Darwin" ]; then
	run_with_spinner "true" "Configuring macOS settings"

	# Enable Touch ID for sudo
	if [ ! -f "/etc/pam.d/sudo_local" ]; then
		run_with_spinner "run_sudo \"sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | tee /etc/pam.d/sudo_local >/dev/null\"" "Enabling Touch ID for sudo"
	fi

	# Install and configure command line tools
	if ! xcode-select -p >/dev/null 2>&1; then
		run_with_spinner "xcode-select --install" "Installing Xcode command line tools"

		# Wait for xcode-select installation to complete
		until xcode-select -p >/dev/null 2>&1; do
			sleep 1
		done
	fi

	# Accept Xcode license
	if ! /usr/bin/xcrun clang >/dev/null 2>&1; then
		run_with_spinner "run_sudo \"xcodebuild -license accept\"" "Accepting Xcode license"
	fi
fi

# Install and configure development tools
run_with_spinner "true" "Installing development tools"

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
	run_with_spinner "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && eval \"\$(/opt/homebrew/bin/brew shellenv)\"" "Installing Homebrew"
fi

# Install applications and tools
run_with_spinner "/opt/homebrew/bin/brew install fzf gh helix lazygit node orbstack posting shfmt starship yazi zoxide" "Installing applications and tools"

# Suppress output for ya pack commands
/opt/homebrew/bin/ya pack -a Lil-Dank/lazygit >/dev/null 2>&1
/opt/homebrew/bin/ya pack -a Rolv-Apneseth/starship >/dev/null 2>&1
/opt/homebrew/bin/ya pack -a yazi-rs/plugins:git >/dev/null 2>&1
/opt/homebrew/bin/ya pack -a yazi-rs/plugins:smart-enter >/dev/null 2>&1

# Authenticate with GitHub CLI (interactive)
printf "\033[1;34m→\033[0m \033[1;37mAuthenticating with GitHub CLI\033[0m\n"
/opt/homebrew/bin/gh auth login -s delete_repo

# Install GitHub CLI extension (suppress output)
/opt/homebrew/bin/gh extension install dlvhdr/gh-dash >/dev/null 2>&1

# Install web tooling
run_with_spinner "/opt/homebrew/bin/npm install -g @tailwindcss/language-server emmet-ls svelte-language-server typescript-language-server vercel vscode-langservers-extracted" "Installing web tooling"

# Install macOS Applications
if [ "$(uname -s)" = "Darwin" ]; then
	run_with_spinner "/opt/homebrew/bin/brew install mas && /opt/homebrew/bin/brew install --cask ghostty homerow hyperkey linear-linear onyx && /opt/homebrew/bin/mas install 1527619437 1662217862 1596283165 634148309 424389933 634159523 497799835 434290957 424390742 1289583905" "Installing macOS applications"
fi

printf "\033[1;32m✔\033[0m \033[1;37mConfiguration complete\033[0m\n"

