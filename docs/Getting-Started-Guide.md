# Getting Started Guide:
Welcome to the Shell Switcher Getting Started Guide! This document will help you set up and configure Shell Switcher quickly and easily. Follow the steps below to get started.

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

The shell switcher uses a comprehensive configuration system to manage user preferences, track usage history, and maintain session information. All configuration files are stored in a dedicated directory following modern standards.

## Configuration Directory Structure

```
$HOME/.config/shell-switcher/
├── config.yaml          # Main configuration (reserved for future use)
├── favorites.txt         # User's favorite shells
├── history.log          # Shell launch history
├── backup.txt           # Backup of previous shell
└── current_session.txt  # Current session information
```

The script follows the XDG Base Directory specification by storing config files in `~/.config/shell-switcher/`. The directory is automatically created on first run.

## Favorites System

### Purpose
Store user's preferred shells for quick access through a dedicated favorites menu.

### File Format
Simple text file (`favorites.txt`) with one shell path per line:
```
/bin/zsh
/usr/local/bin/fish
/bin/bash
```

### Available Commands
```bash
# Add to favorites
./shell-switcher.sh --add-favorite /bin/zsh

# Remove from favorites
./shell-switcher.sh --remove-favorite /bin/zsh

# Show favorites list
./shell-switcher.sh --show-favorites

# Launch favorites menu
./shell-switcher.sh --favorites
```

### Features
- Prevents duplicate entries
- Shows current shell indicator
- Displays shell descriptions
- Falls back to all shells if no favorites configured

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
shell-switcher --history
```

### Logged Events
- Shell launches
- Favorite additions/removals
- Shell backups
- Configuration changes

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
shell-switcher --backup
```

### Automatic Backup
The system automatically backs up your current shell when launching a new one through the session management system.

## Session Tracking

### Purpose
Track detailed information about the currently launched shell session for debugging and reference.

### File Format
Key-value pairs in `current_session.txt`:
```
PARENT_SHELL=/bin/bash
NEW_SHELL=/bin/zsh
SESSION_START=2024-01-15 14:30:22
PID=12345
```

### Usage
```bash
# View current session info
shell-switcher --session-info

# Show current shell with session data
shell-switcher --current
```

### Session Data
- **PARENT_SHELL**: The shell you launched from
- **NEW_SHELL**: The shell currently running
- **SESSION_START**: When the session began
- **PID**: Process ID of the session

## Export/Import System

### Export Configuration
Export your entire configuration to a portable JSON file:

```bash
# Export to default file
shell-switcher --export

# Export to custom location
shell-switcher --export my-shell-config.json
```

### Export Format
```json
{
  "version": "2.1.0",
  "current_shell": "/bin/bash",
  "favorites": ["/bin/zsh", "/usr/local/bin/fish"],
  "backup_shell": "/bin/bash",
  "export_date": "2024-01-15T14:30:22-05:00"
}
```

### Import Configuration
```bash
# Import from file
shell-switcher --import my-shell-config.json
```

> **Note**: Import functionality is basic and recommended for advanced users. Manual review of imported configurations is advised.

## Configuration Workflow

### Initial Setup
1. **First Run**: Creates `~/.config/shell-switcher/` directory automatically
2. **Add Favorites**: Configure your preferred shells for quick access
3. **Test Shells**: Use the interactive menu to explore available options

### Daily Usage Flow
1. **Launch Shell**: Automatically logs action and creates session tracking
2. **Session Management**: Current session info available anytime
3. **History Tracking**: All activities logged with timestamps
4. **Easy Return**: Type `exit` to return to previous shell

### Example Setup Workflow
```bash
# Set up your favorite shells
shell-switcher --add-favorite /bin/zsh
shell-switcher --add-favorite /usr/local/bin/fish
shell-switcher --add-favorite /bin/bash

# Backup current shell
shell-switcher --backup

# Use favorites menu for quick access
shell-switcher --favorites

# Launch a specific shell
shell-switcher --quick zsh

# Check what you've been using
shell-switcher --history

# View current session
shell-switcher --session-info
```

## File Management

### Manual Editing
All configuration files are plain text and can be manually edited:
- **favorites.txt**: Add/remove shell paths (one per line)
- **history.log**: View usage patterns (don't edit)
- **backup.txt**: Contains single shell path reference

### Backup and Sync
The entire `~/.config/shell-switcher/` directory can be:
- Backed up with your dotfiles
- Synced across machines
- Version controlled with git
- Restored from backups

### Cleanup
```bash
# Remove all configuration (start fresh)
rm -rf ~/.config/shell-switcher/

# Clear just history
rm ~/.config/shell-switcher/history.log

# Reset favorites
rm ~/.config/shell-switcher/favorites.txt
```

## Troubleshooting

### Missing Configuration Directory
If the config directory doesn't exist, it will be created automatically on next run.

### Corrupted Files
All config files are plain text. If corrupted:
1. Delete the problematic file
2. Run the script again
3. The file will be recreated as needed

### Permission Issues
Ensure the config directory is writable:
```bash
chmod 755 ~/.config/shell-switcher/
chmod 644 ~/.config/shell-switcher/*
```

### Export/Import Problems
- Verify JSON syntax in export files
- Check file permissions
- Ensure proper file paths in imported configurations

The configuration system is designed to be robust, human-readable, and easy to manage, providing both automated convenience and manual control when needed.