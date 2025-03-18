#!/bin/bash

# Arch Linux Setup Script
# Author: Linus
# Description: Automates the setup of a new Arch Linux installation with preferred packages and configurations

set -e  # Exit on error

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$(id -u)" = 0 ]; then
    log_error "This script should not be run as root or with sudo"
    exit 1
fi

echo "Starting system setup..."

# Update system
echo "Updating system packages..."
sudo pacman -Syyu --noconfirm

# Install base packages
log_info "Installing base packages..."
sudo pacman -S --noconfirm --needed \
    git \
    neovim \
    ripgrep \
    fd \
    unzip \
    gcc \
    make \
    go \
    alacritty \
    python-gpgme \
    pass \
    fzf \
    tmux \
    bat \
    exa \
    htop \
    docker \
    docker-compose \
    gnugpg \
    rsync \
    openssh \
    man-db \
    man-pages

# Install AUR helper (yay)
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
fi

# Install AUR packages
echo "Installing AUR packages..."
yay -S --noconfirm \
    nextcloud-client

# Optional packages (uncomment if needed)
# yay -S --noconfirm dropbox
sudo pacman -S --noconfirm discord obsidian

# Set up Git configuration
echo "Setting up Git configuration..."
git config --global user.email "linus.breitenberger@gmail.com"
git config --global user.name "Linus"

# Set up password manager
echo "Setting up password manager..."
mkdir -p ~/.password-store
pass git init
# The following line is commented out as it requires your server to be set up
# pass git remote add origin kexec.com:pass-store

# Set up Neovim
log_info "Setting up Neovim..."
if [ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" ]; then
    git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
    log_success "Neovim kickstart configuration installed"
else
    log_warning "Neovim configuration already exists, skipping installation"
fi

# Set up shell aliases and functions
log_info "Setting up shell configuration..."
SHELL_RC="${HOME}/.bashrc"
if [ -f "${HOME}/.zshrc" ]; then
    SHELL_RC="${HOME}/.zshrc"
fi

cat >> "$SHELL_RC" << 'EOL'

# Custom aliases
alias ls='exa --color=auto --icons'
alias ll='exa -la --color=auto --icons'
alias grep='grep --color=auto'
alias vim='nvim'
alias cat='bat'
alias top='htop'
alias update='sudo pacman -Syyu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# GPG for pass
export GPG_TTY=$(tty)
EOL

log_success "Shell configuration updated"

# Create standard directories
echo "Creating standard directories..."
mkdir -p ~/Github
mkdir -p ~/Downloads
mkdir -p ~/Nextcloud/obsidian

# Download configuration files from your GitHub repository
# Uncomment and modify these lines when you've set up your config repository
# echo "Downloading configuration files..."
# git clone https://github.com/yourusername/dotfiles.git /tmp/dotfiles
# cp -r /tmp/dotfiles/.config/* ~/.config/
# rm -rf /tmp/dotfiles

# Set up systemd services
log_info "Setting up systemd services..."
if command -v docker &> /dev/null; then
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    sudo usermod -aG docker $USER
    log_success "Docker service enabled and current user added to docker group"
fi

# Create a summary of installed packages and save it for reference
log_info "Creating installation summary..."
mkdir -p "${HOME}/.local/share/system-setup"
pacman -Q > "${HOME}/.local/share/system-setup/packages-$(date +%Y%m%d).txt"
log_success "Installation summary created at ${HOME}/.local/share/system-setup/packages-$(date +%Y%m%d).txt"

# Create a backup script
log_info "Creating backup script..."
mkdir -p "${HOME}/bin"

cat > "${HOME}/bin/backup-config.sh" << 'EOL'
#!/bin/bash
BACKUP_DIR="${HOME}/Nextcloud/backups/$(hostname)"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/config-backup-$(date +%Y%m%d).tar.gz"

# Files to back up
tar -czf "$BACKUP_FILE" \
    -C "$HOME" \
    .config/nvim \
    .config/alacritty \
    .config/bspwm \
    .config/kitty \
    .gitconfig \
    .password-store \
    bin

echo "Backup created at $BACKUP_FILE"
EOL
chmod +x "${HOME}/bin/backup-config.sh"
log_success "Backup script created at ${HOME}/bin/backup-config.sh"

# Create future setup notes
log_info "Creating personalized post-setup todo list..."
cat > "${HOME}/post-setup-tasks.md" << 'EOL'
# Post-Setup Tasks

## Manual Configuration
- [ ] Initialize GPG key for password store
- [ ] Set up GitHub SSH key
- [ ] Sync Nextcloud for personal files
- [ ] Configure Obsidian vault
- [ ] Customize alacritty/kitty terminal settings

## Development Environment
- [ ] Clone common GitHub repositories
- [ ] Set up language-specific tools (Node.js, Python, etc.)
- [ ] Configure Docker environments
EOL
log_success "Post-setup tasks created at ${HOME}/post-setup-tasks.md"

log_success "Setup complete! Please restart your terminal or system to apply all changes."
echo ""
echo "Don't forget to:"
echo "1. Check ${HOME}/post-setup-tasks.md for additional manual setup steps"
echo "2. Run 'source ${SHELL_RC}' to apply shell changes without restarting"
echo "3. Use ${HOME}/bin/backup-config.sh periodically to back up your configuration"
