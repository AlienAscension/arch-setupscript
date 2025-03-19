# Personal Tool Installscript

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

### 1. Fork this repository

You *can* clone this one, though it is recommended to improve upon this yourself.

### 2. Clone this repository

```shell-session
git clone git@github.com:AlienAscension/bmzn-config.git
```

replace *AlienAscension* with your username.

### 3. Edit .env-example

1. Use your favourite editor to adjust the `.env-example` accordingly.
2. Rename it to `.env`

```shell-session
mv .env-example .env
```

### 4. Make the script Executable & run it

```bash
chmod +x setup.sh
./setup.sh
```

## Post-Installation Steps

1. Restart the terminal or system
2. Check `post-setup-tasks.md` for additional steps
3. Run `source ~/.bashrc` or `source ~/.zshrc` to apply shell changes
4. Use `~/bin/backup-config.sh` to periodically back up configurations

## Contributing

Feel free to submit pull requests to improve the script or README.

## License

This project is licensed under the MIT License.
