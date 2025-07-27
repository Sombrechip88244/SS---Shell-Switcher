% SHELL-SWITCHER(1) User Commands
% Sombrechip88244
% July 2025

# NAME
shell-switcher.sh – Advanced shell switcher with backup, favorites, and more

# SYNOPSIS
**shell-switcher.sh** [OPTIONS]

# DESCRIPTION
Advanced shell switcher for power users and beginners alike. Supports favorites, backup/restore, shell information, and more.

# OPTIONS

## BASIC OPTIONS
**-h**, **--help**
:   Show this help message

**-v**, **--version**
:   Show version information

**--list**
:   List all available shells

**--list-detailed**
:   List shells with descriptions

**--current**
:   Show current shell

**--interactive**
:   Run interactive menu (default)

**--favorites**
:   Show favorite shells menu

## SHELL MANAGEMENT
**--set <shell>**
:   Change to specified shell directly

**--dry-run <shell>**
:   Show what would happen without changing

**--info <shell>**
:   Show detailed information about a shell

**--check**
:   Health check for all shells

**--recommend**
:   Show shell recommendations

## FAVORITES
**--add-favorite <shell>**
:   Add shell to favorites

**--remove-favorite <shell>**
:   Remove shell from favorites

**--show-favorites**
:   List favorite shells

## BACKUP & RESTORE
**--backup**
:   Backup current shell

**--restore**
:   Restore previous shell

**--history**
:   Show shell change history

## ADVANCED
**--plugins <shell>**
:   Show plugins/frameworks for shell

**--export [file]**
:   Export configuration

**--import <file>**
:   Import configuration

**--no-prompt**
:   Skip confirmation prompts

# EXAMPLES
```
shell-switcher.sh                    # Interactive menu
shell-switcher.sh --set /bin/zsh     # Change to zsh directly
shell-switcher.sh --info zsh         # Show zsh information
shell-switcher.sh --favorites        # Show favorites menu
shell-switcher.sh --backup           # Backup current shell
shell-switcher.sh --check            # Health check all shells
```

# FILES

Config Directory: /Users/oliverfildes/.config/shell-switcher  
Favorites:       /Users/oliverfildes/.config/shell-switcher/favorites.txt  
History:         /Users/oliverfildes/.config/shell-switcher/history.log  
Backup:          /Users/oliverfildes/.config/shell-switcher/backup.txt  

# AUTHOR
Created by Sombrechip88244  
GitHub: <https://github.com/Sombrechip88244/SS---Shell-Switcher>

# LICENSE
GNU General Public License v3.0
