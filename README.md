# My personal setup script for Software & Tools I most commonly use.

## Overview
This script automates the setup of a fresh Arch Linux installation by installing essential packages, setting up configurations, and applying useful customizations.

## Features
- Updates system packages
- Installs essential packages from Arch repositories and the AUR
- Sets up Git configuration
- Configures Neovim with a kickstart setup
- Adds useful shell aliases and functions
- Creates standard directories
- Sets up Docker and enables the service
- Generates a backup script for critical configurations
- Provides a post-setup checklist

## Prerequisites
- A running Arch Linux installation
- Internet connection
- A non-root user with sudo privileges

## Installation
### 1. Download the Script
```bash
curl -O https://raw.githubusercontent.com/yourusername/setupscript/main/setup.sh
```

### 2. Make it Executable
```bash
chmod +x setup.sh
```

### 3. Run the Script
```bash
./setup.sh
```

## What the Script Does
### Updates System Packages
```bash
sudo pacman -Syyu --noconfirm
```

### Installs Essential Packages
```bash
sudo pacman -S --noconfirm --needed git neovim ripgrep fd unzip gcc make go alacritty pass fzf tmux bat exa htop docker docker-compose gpg rsync openssh man-db man-pages
```

### Installs AUR Packages (via yay)
If `yay` is not installed, the script installs it first.
```bash
yay -S --noconfirm nextcloud-client discord obsidian
```

### Configures Git
```bash
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

### Configures Neovim
If no configuration exists, it clones the `kickstart.nvim` repository.

### Adds Shell Aliases and Functions
Modifies `.bashrc` or `.zshrc` to include custom aliases and functions.

### Sets Up Docker
Enables Docker service and adds the user to the Docker group:
```bash
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker $USER
```

### Creates a Backup Script
A script is created in `~/bin/backup-config.sh` to back up essential configuration files.

### Generates a Post-Setup Checklist
A `post-setup-tasks.md` file is created, listing additional manual configuration steps.

## Post-Installation Steps
1. Restart the terminal or system
2. Check `post-setup-tasks.md` for additional steps
3. Run `source ~/.bashrc` or `source ~/.zshrc` to apply shell changes
4. Use `~/bin/backup-config.sh` to periodically back up configurations

## Contributing
Feel free to submit pull requests to improve the script or README.

## License
This project is licensed under the MIT License.

