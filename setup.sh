#!/bin/sh
# `curl -sSL https://raw.githubusercontent.com/maclong9/dots/refs/heads/main/setup.sh | sh`

# Restore System to Previous State If Non-Zero Exit Code
trap 'cleanup' EXIT
cleanup() {
	if [ $? -ne 0 ]; then
		sudo rm -rf "$HOME"/.config "$HOME"/.gitconfig "$HOME"/.gitignore \
			"$HOME"/.vim "$HOME"/.vimrc "$HOME"/.zshrc /etc/pam.d/sudo_local
		(crontab -l 2>/dev/null | sed '$d;$d') | crontab -
	fi
}

# Check If Running on macOS
if [ "$(uname -s)" = "Darwin" ]; then
	# Enable Touch ID for `sudo`
	sudo sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local >/dev/null

	# Install Developer Tools
	xcode-select -p >/dev/null 2>&1 && xcode-select --install

	# Accept Developer Tools License
	/usr/bin/xcrun clang >/dev/null 2>&1 && sudo xcodebuild -license accept
fi

# Clone Configuration Files and Symlink to Home Directory
git clone https://github.com/maclong9/dots .config
for file in .config/.*; do
	case "$(basename "$file")" in
	"." | ".." | ".git") continue ;;
	*) ln -s "$file" "$HOME/$(basename "$file")" ;;
	esac
done

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >>/Users/maclong/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/maclong/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Tooling and Apps
HB_PATH="/opt/homebrew/bin"
"$HB_PATH/brew" install --cask ghostty hammerspoon homerow hyperkey onyx
"$HB_PATH/brew" install deno fd ffmpeg fzf helix imagemagick jq lazygit marksman mas \
	node poppler ripgrep starship yazi zoxide
"$HB_PATH/brew" install pnpm

# Setup pnpm and Install Language Servers
echo 'export PNPM_HOME="/Users/maclong/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac' >> "$HOME/.profile"
. "$HOME/.profile"
"$HB_PATH/pnpm" setup
"$HB_PATH/pnpm" i -g @tailwindcss/language-server emmet-ls svelte-language-server \
	turbo typescript-language-server vercel vscode-langservers-extracted

# Install App Store Applications
"$HB_PATH/mas" install 1527619437 1662217862 1622835804 1596283165 634148309 \
	424389933 634159523 497799835 434290957 424390742

# Setup Cron Tasks
(crontab -l 2>/dev/null; echo "0 10 * * * $HOME/.save-the-world.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 10 * * 0 brew update && brew upgrade") | crontab -
(crontab -l 2>/dev/null; echo "0 12 * * 0 open /Applications/OnyX.app") | crontab -

printf "\033[1;32m✔\033[0m \033[1;37mConfiguration complete\033[0m\n"
