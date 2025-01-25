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
	sudo sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local > /dev/null
	
	# Install Developer Tools
	! xcode-select -p >/dev/null 2>&1 && xcode-select --install
	
	# Accept Developer Tools License
	! /usr/bin/xcrun clang >/dev/null 2>&1 && sudo xcodebuild -license accept
fi

# Clone Configuration Files and Symlink to Home Directory
git clone https://github.com/maclong9/dots .config
for file in .config/.*; do
	case "$(basename "$file")" in
		"." | ".." | ".git") continue ;;
		*) ln -s "$file" "$HOME/$(basename "$file")" ;;
	esac
done

# Setup Developer Tooling
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> /Users/maclong/.zprofile
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/maclong/.zprofile
   eval "$(/opt/homebrew/bin/brew shellenv)"
/opt/homebrew/bin/brew install --cask ghostty hammerspoon homerow hyperkey onyx 
/opt/homebrew/bin/brew install deno helix marksman mas node zoxide && \
/opt/homebrew/bin/brew install pnpm 

/opt/homebrew/bin/pnpm setup
/opt/homebrew/bin/pnpm i -g @tailwindcss/language-server svelteserver typescript-language-server vscode-langservers-extracted 
mas install 1527619437 1662217862

# Setup Cron Tasks
(crontab -l 2>/dev/null; echo "0 10 * * * $HOME/.save-the-world.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 10 * * 0 open /Applications/OnyX.app") | crontab -

printf "\033[1;32m✔\033[0m \033[1;37mConfiguration complete\033[0m\n"
