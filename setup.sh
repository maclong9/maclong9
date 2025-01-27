#!/bin/sh
# macOS Development Environment Setup Script
# Downloads configuration files and sets up development environment with necessary tooling
# Usage: curl -sSL https://raw.githubusercontent.com/maclong9/dots/refs/heads/main/setup.sh | sh

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Cleanup function to restore system state on non-zero exit
cleanup() {
    if [ $? -ne 0 ]; then
        printf "\033[1;31m✗\033[0m \033[1;37mSetup failed, restoring system state\033[0m\n"
        sudo rm -rf "${HOME}/.config" \
                   "${HOME}/.gitconfig" \
                   "${HOME}/.gitignore" \
                   "${HOME}/.vim" \
                   "${HOME}/.vimrc" \
                   "${HOME}/.zshrc" \
                   /etc/pam.d/sudo_local
        (crontab -l 2>/dev/null | sed '$d;$d;$d') | crontab -
        exit 1
    fi
}
trap cleanup EXIT

# Clone and symlink configuration files
printf "\033[1;34m→\033[0m \033[1;37mCloning configuration files\033[0m\n"
git clone https://github.com/maclong9/dots .config
for file in .config/.*; do
    case "$(basename "$file")" in
        "." | ".." | ".git") continue ;;
        *) ln -sf "$file" "${HOME}/$(basename "$file")" ;;
    esac
done

# macOS specific setup
if [ "$(uname -s)" = "Darwin" ]; then
    printf "\033[1;34m→\033[0m \033[1;37mConfiguring macOS settings\033[0m\n"
    
    # Enable Touch ID for sudo
    sudo sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | \
        sudo tee /etc/pam.d/sudo_local >/dev/null
    
    # Install and configure Developer Tools
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install
        # Wait for xcode-select installation to complete
        until xcode-select -p >/dev/null 2>&1; do
            sleep 1
        done
    fi
    
    if ! /usr/bin/xcrun clang >/dev/null 2>&1; then
        sudo xcodebuild -license accept
    fi
fi

# Setup cron tasks
printf "\033[1;34m→\033[0m \033[1;37mConfiguring scheduled tasks\033[0m\n"
(crontab -l 2>/dev/null || true; echo "0 10 * * * ${HOME}/.save-the-world.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 10 * * 0 brew update && brew upgrade") | crontab -
(crontab -l 2>/dev/null; echo "0 12 * * 0 open /Applications/OnyX.app") | crontab -

# Install and configure development tools
printf "\033[1;34m→\033[0m \033[1;37mInstalling development tools\033[0m\n"

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install applications and tools
BREW_PREFIX="/opt/homebrew"
"${BREW_PREFIX}/bin/brew" install --cask ghostty hammerspoon homerow hyperkey onyx
"${BREW_PREFIX}/bin/brew" install fzf helix lazygit mas node pnpm starship yazi zoxide

# Configure pnpm
if ! grep -q PNPM_HOME "${HOME}/.profile" 2>/dev/null; then
    cat >> "${HOME}/.profile" << 'EOF'
export PNPM_HOME="${HOME}/Library/pnpm"
case ":${PATH}:" in
    *":${PNPM_HOME}:"*) ;;
    *) export PATH="${PNPM_HOME}:${PATH}" ;;
esac
EOF
fi
. "${HOME}/.profile"

# Setup pnpm and install language servers
"${BREW_PREFIX}/bin/pnpm" setup
"${BREW_PREFIX}/bin/pnpm" install -g \
    @tailwindcss/language-server \
    emmet-ls \
    svelte-language-server \
    turbo \
    typescript-language-server \
    vercel \
    vscode-langservers-extracted

# Install App Store applications
if [ "$(uname -s)" = "Darwin" ]; then
    "${BREW_PREFIX}/bin/mas" install \
        1527619437 1662217862 1596283165 634148309 424389933 \
        634159523 497799835 434290957 424390742
fi

printf "\033[1;32m✔\033[0m \033[1;37mConfiguration complete\033[0m\n"
