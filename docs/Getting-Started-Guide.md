# Getting Started Guide:
Welcome to the SS Getting Started Guide! This document will help you set up and configure SS quickly and easily. Follow the steps below to get started.

## Install
### Dependencies
- Brew
- Git
- Bash, zsh or sh

#### Brew:
You can install Brew using this command
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
#### Git:
git should be pre-installed but if not:
##### Debian/Ubuntu
```
sudo apt install git
```
##### Fedora
```
yum install git (up to Fedora 21)
```
```
dnf install git (Fedora 22 and later) 
```
##### Gentoo
```
emerge --ask --verbose dev-vcs/git
```
##### Arch
```
pacman -S git
```
##### Open suse
```
zypper install git
```
##### Mageia
```
urpmi git
```
##### Nix/Nix OS
```
nix-env -i git
```
##### FreeBSD
```
pkg install git
```
##### Solaris 9/10/11 (OpenCSW)
```
pkgutil -i git
```
##### Solaris 11 Express, OpenIndiana
```
pkg install developer/versioning/git
```
##### OpenBSD
```
pkg_add git
```
##### Alpine
```
apk add git
```
##### Red Hat Enterprise Linux, Oracle Linux, CentOS, Scientific Linux, et al.
RHEL and derivatives typically ship older versions of git. You can [download a tarball](https://www.kernel.org/pub/software/scm/git/) and build from source, or use a 3rd-party repository such as the [IUS Community Project](https://ius.io/) to obtain a more recent version of git.
##### Slitaz
```
tazpkg get-install git
```

## Configuration System

The SS uses a comprehensive configuration system to manage user preferences, track usage history, and maintain session information. All configuration files are stored in a dedicated directory following modern standards.

## Configuration Directory Structure

```
$HOME/.config/ss/
├── config.yaml          # Main configuration (reserved for future use)
├── favorites.txt         # User's favorite shells
├── history.log          # Shell launch history
├── backup.txt           # Backup of previous shell
└── current_session.txt  # Current session information
```

The script follows the XDG Base Directory specification by storing config files in `~/.config/ss/`. The directory is automatically created on first run.

### Available Commands
```bash
# Add to favorites
ss --add-favorite /bin/zsh

# Remove from favorites
ss --remove-favorite /bin/zsh

# Show favorites list
ss --show-favorites

# Launch favorites menu
ss --favorites
```

### Features
- Prevents duplicate entries
- Shows current shell indicator
- Displays shell descriptions
- Falls back to all shells if no favorites configured

### Usage
```bash
# View recent history (last 20 entries)
ss --history
```

## History System

### Purpose
Track all shell launches and configuration changes with timestamps for debugging and usage analysis.

### File Format
Timestamped log entries in `history.log`:
```
2024-01-15 14:30:22 - Launched shell: /bin/zsh (from /bin/bash)
2024-01-15 14:35:10 - Added favorite: /usr/local/bin/fish
2024-01-15 14:40:05 - Backed up shell: /bin/bash
```

### Usage
```bash
# View recent history (last 20 entries)
ss --history
```

### Logged Events
- Shell launches
- Favorite additions/removals
- Shell backups
- Configuration changes

### Usage
```bash
# Manually backup current shell
ss --backup
```

## Backup System

### Purpose
Store reference to the shell you were using before launching a new one, enabling easy restoration.

### File Format
Single line in `backup.txt` containing the shell path:
```
/bin/bash
```

### Usage
```bash
# Manually backup current shell
ss --backup
```

### Automatic Backup
The system automatically backs up your current shell when launching a new one through the session management system.

### Usage
```bash
# View current session info
ss --session-info

# Show current shell with session data
ss --current
```

## Export Configuration

### Usage
```bash
# Export to default file
ss --export

# Export to custom location
ss --export my-shell-config.json
```

### Import Configuration
```bash
# Import from file
ss --import my-shell-config.json
```

### Initial Setup
1. **First Run**: Creates `~/.config/ss/` directory automatically
2. **Add Favorites**: Configure your preferred shells for quick access
3. **Test Shells**: Use the interactive menu to explore available options

### Example Setup Workflow
```bash
# Set up your favorite shells
ss --add-favorite /bin/zsh
ss --add-favorite /usr/local/bin/fish
ss --add-favorite /bin/bash

# Backup current shell
ss --backup

# Use favorites menu for quick access
ss --favorites

# Launch a specific shell
ss --quick zsh

# Check what you've been using
ss --history

# View current session
ss --session-info
```

### Cleanup
```bash
# Remove all configuration (start fresh)
rm -rf ~/.config/ss/

# Clear just history
rm ~/.config/ss/history.log

# Reset favorites
rm ~/.config/ss/favorites.txt
```

### Permission Issues
Ensure the config directory is writable:
```bash
chmod 755 ~/.config/ss/w