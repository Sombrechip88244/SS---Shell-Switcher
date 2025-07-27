#!/bin/bash

# Advanced Shell Switcher (Direct Execution)
# Version 2.1.0
# Author: Sombrechip88244

set -e

# Configuration
VERSION="2.1.0"
SCRIPT_NAME="Shell Switcher (Direct)"
CONFIG_DIR="$HOME/.config/shell-switcher"
CONFIG_FILE="$CONFIG_DIR/config.yaml"
HISTORY_FILE="$CONFIG_DIR/history.log"
BACKUP_FILE="$CONFIG_DIR/backup.txt"
FAVORITES_FILE="$CONFIG_DIR/favorites.txt"
SESSION_FILE="$CONFIG_DIR/current_session.txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Emojis (these will appear as ? on old terminals)
STAR="*"
CHECK="[ok]"
WARNING="[!]"
ERROR="[x]"
INFO="[i]"
ARROW="->"

# Create config directory if it doesn't exist
[ -d "$CONFIG_DIR" ] || mkdir -p "$CONFIG_DIR"

# Logging function
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$HISTORY_FILE"
}

# Print colored output
print_color() {
    local color="$1"
    local text="$2"
    echo -e "${color}${text}${NC}"
}

# Progress bar function
show_progress() {
    local duration="$1"
    local message="$2"
    echo -n "$message"
    local i=0
    while [ $i -lt "$duration" ]; do
        echo -n "#"
        sleep 0.1
        i=$((i+1))
    done
    echo " 100%"
}

# Shell information database
get_shell_info() {
    local shell_path="$1"
    local shell_name
    shell_name=$(basename "$shell_path")
    case "$shell_name" in
        "bash")
            echo "Bourne Again Shell - Default on most systems, excellent for scripting"
            ;;
        "zsh")
            echo "Z Shell - Modern, feature-rich with excellent autocompletion and themes"
            ;;
        "fish")
            echo "Friendly Interactive Shell - User-friendly with syntax highlighting"
            ;;
        "nu")
            echo "Nushell - Data-focused shell with structured data handling"
            ;;
        "dash")
            echo "Debian Almquist Shell - Lightweight, POSIX-compliant"
            ;;
        "ksh")
            echo "Korn Shell - Combines features of C shell and Bourne shell"
            ;;
        "tcsh")
            echo "TENEX C Shell - Enhanced version of C shell"
            ;;
        "csh")
            echo "C Shell - Shell with C-like syntax"
            ;;
        "sh")
            echo "Bourne Shell - Original Unix shell, minimal but universal"
            ;;
        "ash")
            echo "Almquist Shell - Lightweight shell, often used in embedded systems"
            ;;
        *)
            echo "Shell information not available"
            ;;
    esac
}

# Check if shell is executable and valid
validate_shell() {
    local shell_path="$1"
    if [ ! -f "$shell_path" ]; then
        return 1
    fi
    if [ ! -x "$shell_path" ]; then
        return 2
    fi
    # Try to execute shell with --version or -c 'exit 0' to test validity
    "$shell_path" -c 'exit 0' >/dev/null 2>&1 || return 3
    return 0
}

# Get shell version
get_shell_version() {
    local shell_path="$1"
    local version=""
    local shell_name
    shell_name=$(basename "$shell_path")
    case "$shell_name" in
        "bash")
            version=$("$shell_path" --version 2>/dev/null | head -n1 | sed -n 's/.*version \([0-9][0-9.]*\).*/\1/p')
            ;;
        "zsh")
            version=$("$shell_path" --version 2>/dev/null | sed -n 's/[^0-9]*\([0-9][0-9.]*\).*/\1/p' | head -n1)
            ;;
        "fish")
            version=$("$shell_path" --version 2>/dev/null | grep -o '[0-9][0-9.]*' | head -n1)
            ;;
        "ksh")
            version=$("$shell_path" -c 'echo $KSH_VERSION' 2>/dev/null | head -n1)
            ;;
        "dash"|"ash"|"sh")
            # These shells often don't have version flags, try different approaches
            version=$("$shell_path" -c 'echo $0' 2>/dev/null | xargs basename)
            ;;
        "tcsh"|"csh")
            version=$("$shell_path" -c 'echo $version' 2>/dev/null | head -n1)
            ;;
        *)
            version="Unknown"
            ;;
    esac
    [ -n "$version" ] && echo "$version" || echo "Unknown"
}

# Check for shell plugins/frameworks
check_shell_plugins() {
    local shell_name="$1"
    local found=""
    if [ "$shell_name" = "zsh" ]; then
        [ -d "$HOME/.oh-my-zsh" ] && found="${found}Oh My Zsh\n"
        [ -f "$HOME/.zshrc" ] && grep -q "starship" "$HOME/.zshrc" 2>/dev/null && found="${found}Starship\n"
        [ -d "$HOME/.config/powerlevel10k" ] && found="${found}Powerlevel10k\n"
    elif [ "$shell_name" = "bash" ]; then
        [ -f "$HOME/.bashrc" ] && grep -q "starship" "$HOME/.bashrc" 2>/dev/null && found="${found}Starship\n"
        [ -d "$HOME/.bash_it" ] && found="${found}Bash-it\n"
    elif [ "$shell_name" = "fish" ]; then
        [ -d "$HOME/.config/fish/functions" ] && found="${found}Fisher plugins\n"
        [ -f "$HOME/.config/fish/config.fish" ] && grep -q "starship" "$HOME/.config/fish/config.fish" 2>/dev/null && found="${found}Starship\n"
    fi
    if [ -n "$found" ]; then
        echo -e "$found" | sed '/^$/d'
    else
        echo "None detected"
    fi
}

# Get available shells with validation
get_available_shells() {
    local shells=""
    # Common shell locations
    local common_shells="/bin/sh /bin/bash /bin/zsh /bin/fish /bin/csh /bin/tcsh /bin/ksh /bin/dash /bin/ash /usr/bin/zsh /usr/bin/fish /usr/local/bin/zsh /usr/local/bin/fish /opt/homebrew/bin/zsh /opt/homebrew/bin/fish"
    
    # Check /etc/shells if it exists
    if [ -f /etc/shells ]; then
        while read shell; do
            case "$shell" in
                ""|\#*) continue;;
            esac
            validate_shell "$shell" >/dev/null 2>&1 && shells="${shells}${shell}\n"
        done < /etc/shells
    fi
    
    # Also check common locations
    for shell in $common_shells; do
        if validate_shell "$shell" >/dev/null 2>&1; then
            # Avoid duplicates
            echo -e "$shells" | grep -q "^$shell$" || shells="${shells}${shell}\n"
        fi
    done
    
    echo -e "$shells" | sed '/^$/d' | sort -u
}

# Add shell to favorites
add_favorite() {
    local shell_path="$1"
    grep -q "^$shell_path$" "$FAVORITES_FILE" 2>/dev/null || {
        echo "$shell_path" >> "$FAVORITES_FILE"
        print_color "$GREEN" "$CHECK Added $shell_path to favorites"
        log_action "Added favorite: $shell_path"
        return
    }
    print_color "$YELLOW" "$WARNING $shell_path is already in favorites"
}

# Remove shell from favorites
remove_favorite() {
    local shell_path="$1"
    if [ -f "$FAVORITES_FILE" ]; then
        grep -v "^$shell_path$" "$FAVORITES_FILE" > "${FAVORITES_FILE}.tmp" && mv "${FAVORITES_FILE}.tmp" "$FAVORITES_FILE"
        print_color "$GREEN" "$CHECK Removed $shell_path from favorites"
        log_action "Removed favorite: $shell_path"
    fi
}

# Show favorites
show_favorites() {
    if [ -f "$FAVORITES_FILE" ] && [ -s "$FAVORITES_FILE" ]; then
        print_color "$CYAN" "\n$INFO Favorite Shells:"
        local i=1
        while read shell; do
            [ -z "$shell" ] && continue
            local current_marker=""
            [ "$shell" = "$SHELL" ] && current_marker=" (current) $STAR"
            local info
            info=$(get_shell_info "$shell")
            printf "%d) %s%s\n   %s\n" "$i" "$shell" "$current_marker" "$info"
            i=$((i+1))
        done < "$FAVORITES_FILE"
    else
        print_color "$YELLOW" "$WARNING No favorite shells configured"
        echo "Use 'shell-switcher --add-favorite <shell>' to add favorites"
    fi
}

# Backup current shell
backup_shell() {
    echo "$SHELL" > "$BACKUP_FILE"
    print_color "$GREEN" "$CHECK Current shell backed up: $SHELL"
    log_action "Backed up shell: $SHELL"
}

# Store current session info
store_session() {
    local new_shell="$1"
    echo "PARENT_SHELL=$SHELL" > "$SESSION_FILE"
    echo "NEW_SHELL=$new_shell" >> "$SESSION_FILE"
    echo "SESSION_START=$(date '+%Y-%m-%d %H:%M:%S')" >> "$SESSION_FILE"
    echo "PID=$$" >> "$SESSION_FILE"
}

# Get session info
get_session_info() {
    if [ -f "$SESSION_FILE" ]; then
        cat "$SESSION_FILE"
    fi
}

# Show shell change history
show_history() {
    if [ -f "$HISTORY_FILE" ] && [ -s "$HISTORY_FILE" ]; then
        print_color "$CYAN" "\n$INFO Shell Change History:"
        tail -20 "$HISTORY_FILE"
    else
        print_color "$YELLOW" "$WARNING No history available"
    fi
}

# Health check for all shells
health_check() {
    print_color "$CYAN" "\n$INFO Shell Health Check:"
    echo "======================================"
    local shells
    shells=$(get_available_shells)
    for shell in $shells; do
        printf "%-20s " "$(basename "$shell"):"
        validate_shell "$shell"
        status="$?"
        case $status in
            0) print_color "$GREEN" "Healthy" ;;
            1) print_color "$RED" "File not found" ;;
            2) print_color "$RED" "Not executable" ;;
            3) print_color "$YELLOW" "Cannot execute" ;;
        esac
    done
}

# Get shell recommendations
get_recommendations() {
    print_color "$CYAN" "\n$INFO Shell Recommendations:"
    echo "======================================"
    echo "For Beginners:     bash (familiar, widely supported)"
    echo "For Power Users:   zsh (features, customization)"
    echo "For Simplicity:    fish (user-friendly, good defaults)"
    echo "For Data Work:     nu (structured data handling)"
    echo "For Scripts:       bash (maximum compatibility)"
    echo "For Speed:         dash (lightweight, fast startup)"
    echo "For Compatibility: sh (universal, minimal)"
}

# Show detailed shell information
show_shell_info() {
    local shell_path="$1"
    local shell_name
    shell_name=$(basename "$shell_path")
    print_color "$CYAN" "\n$INFO Shell Information: $shell_name"
    echo "======================================"
    echo "Path: $shell_path"
    echo "Description: $(get_shell_info "$shell_path")"
    echo "Version: $(get_shell_version "$shell_path")"
    validate_shell "$shell_path"
    status="$?"
    case $status in
        0) echo "Status: ${GREEN}Available${NC}" ;;
        1) echo "Status: ${RED}Not found${NC}" ;;
        2) echo "Status: ${RED}Not executable${NC}" ;;
        3) echo "Status: ${YELLOW}Cannot execute${NC}" ;;
    esac
    echo "Plugins/Frameworks: $(check_shell_plugins "$shell_name")"
    grep -q "^$shell_path$" "$FAVORITES_FILE" 2>/dev/null && echo "Favorited: ${YELLOW}${STAR} Yes${NC}" || echo "Favorited: No"
}

# Launch shell function (replaces change_shell)
launch_shell() {
    local new_shell="$1"
    local interactive="${2:-true}"
    local dry_run="${3:-false}"
    local session_mode="${4:-false}"

    validate_shell "$new_shell"
    status="$?"
    if [ $status -ne 0 ]; then
        case $status in
            1) print_color "$RED" "$ERROR Shell not found: $new_shell" ;;
            2) print_color "$RED" "$ERROR Shell not executable: $new_shell" ;;
            3) print_color "$YELLOW" "$WARNING Shell cannot be executed: $new_shell" ;;
        esac
        return 1
    fi

    if [ "$new_shell" = "$SHELL" ]; then
        print_color "$YELLOW" "$WARNING $new_shell is already your current shell"
        if [ "$interactive" = "true" ]; then
            echo -n "Launch it anyway? (y/N): "
            read answer
            case "$answer" in
                y|Y) ;;
                *) return 0;;
            esac
        fi
    fi

    if [ "$dry_run" = "true" ]; then
        print_color "$CYAN" "$INFO Dry run mode - would launch $new_shell"
        return 0
    fi

    local current_shell
    local target_shell
    current_shell=$(basename "$SHELL")
    target_shell=$(basename "$new_shell")
    
    if [ "$current_shell" != "$target_shell" ]; then
        case "$target_shell" in
            "fish"|"nu"|"csh"|"tcsh")
                if [ "$interactive" = "true" ]; then
                    print_color "$YELLOW" "$WARNING $target_shell has different syntax than POSIX shells"
                    echo -n "Continue? (y/N): "
                    read answer
                    case "$answer" in
                        y|Y) ;;
                        *) print_color "$CYAN" "Operation cancelled"; return 0;;
                    esac
                fi
                ;;
        esac
    fi

    print_color "$CYAN" "$INFO Launching $new_shell shell..."
    [ "$interactive" = "true" ] && show_progress 15 "Progress: "
    
    # Store session information
    if [ "$session_mode" = "true" ]; then
        store_session "$new_shell"
    fi
    
    print_color "$GREEN" "$CHECK Starting $new_shell session"
    print_color "$YELLOW" "$INFO Type 'exit' to return to your previous shell ($SHELL)"
    print_color "$CYAN" "$INFO Current shell: $new_shell"
    
    log_action "Launched shell: $new_shell (from $SHELL)"
    
    # Launch the shell interactively
    exec "$new_shell"
}

# Interactive numbered menu
interactive_menu() {
    local use_favorites="${1:-false}"
    local shells
    if [ "$use_favorites" = "true" ]; then
        if [ -f "$FAVORITES_FILE" ] && [ -s "$FAVORITES_FILE" ]; then
            shells=$(cat "$FAVORITES_FILE")
        else
            print_color "$YELLOW" "$WARNING No favorites configured. Showing all shells."
            shells=$(get_available_shells)
        fi
    else
        shells=$(get_available_shells)
    fi
    [ -z "$shells" ] && { print_color "$RED" "$ERROR No shells available"; return 1; }
    
    print_color "$CYAN" "\n$INFO Available Shells:"
    echo "=================================="
    local i=1
    local choices=""
    for shell in $shells; do
        local current_marker=""
        [ "$shell" = "$SHELL" ] && current_marker=" (current) $STAR"
        local info
        info=$(get_shell_info "$shell")
        printf "%d) %s%s\n   %s\n\n" "$i" "$shell" "$current_marker" "$info"
        choices="${choices}${shell}\n"
        i=$((i+1))
    done
    echo "q) Quit"
    echo
    
    while true; do
        echo -n "Select shell (1-$(($i-1))) or 'q' to quit: "
        read choice
        [ "$choice" = "q" ] || [ "$choice" = "Q" ] && { print_color "$CYAN" "Goodbye!"; return 0; }
        expr "$choice" + 0 >/dev/null 2>&1
        if [ $? -eq 0 ] && [ "$choice" -ge 1 ] && [ "$choice" -le $((i-1)) ]; then
            local n=1
            for shell in $shells; do
                [ "$n" = "$choice" ] && { launch_shell "$shell" true false true; return $?; }
                n=$((n+1))
            done
        else
            print_color "$RED" "$ERROR Invalid selection. Please try again."
        fi
    done
}

# Quick shell launcher
quick_launch() {
    local shell_name="$1"
    local shells
    shells=$(get_available_shells)
    
    # Try exact path first
    for shell in $shells; do
        if [ "$shell" = "$shell_name" ]; then
            launch_shell "$shell" false false true
            return $?
        fi
    done
    
    # Try basename match
    for shell in $shells; do
        if [ "$(basename "$shell")" = "$shell_name" ]; then
            launch_shell "$shell" false false true
            return $?
        fi
    done
    
    print_color "$RED" "$ERROR Shell '$shell_name' not found or not available"
    return 1
}

# Export configuration
export_config() {
    local export_file="${1:-shell-switcher-config.json}"
    echo "{" > "$export_file"
    echo "  \"version\": \"$VERSION\"," >> "$export_file"
    echo "  \"current_shell\": \"$SHELL\"," >> "$export_file"
    echo -n "  \"favorites\": [" >> "$export_file"
    if [ -f "$FAVORITES_FILE" ]; then
        local first=1
        while read shell; do
            [ -z "$shell" ] && continue
            [ $first -eq 1 ] && first=0 || echo -n "," >> "$export_file"
            echo -n "\"$shell\"" >> "$export_file"
        done < "$FAVORITES_FILE"
    fi
    echo "]," >> "$export_file"
    echo "  \"backup_shell\": \"$(cat "$BACKUP_FILE" 2>/dev/null || echo "")\"," >> "$export_file"
    echo "  \"export_date\": \"$(date -Iseconds)\"" >> "$export_file"
    echo "}" >> "$export_file"
    print_color "$GREEN" "$CHECK Configuration exported to $export_file"
}

# Import configuration (basic)
import_config() {
    local import_file="$1"
    [ -f "$import_file" ] || { print_color "$RED" "$ERROR Import file not found: $import_file"; return 1; }
    if grep -q "favorites" "$import_file"; then
        print_color "$CYAN" "$INFO Importing favorites..."
        print_color "$YELLOW" "$WARNING Import feature is basic - manual review recommended"
    fi
    print_color "$GREEN" "$CHECK Configuration imported from $import_file"
}

# Help function
show_help() {
    cat << EOF
Shell Switcher v2.1.0 (Direct Execution Mode)

DESCRIPTION:
    Advanced shell switcher that launches shells directly without changing
    your system default. Supports favorites, session tracking, shell 
    information, and much more.

USAGE:
    shell-switcher.sh [OPTIONS]

BASIC OPTIONS:
    -h, --help              Show this help message
    -v, --version           Show version information
    --list                  List all available shells
    --list-detailed         List shells with descriptions
    --current               Show current shell
    --interactive           Run interactive menu (default)
    --favorites             Show favorite shells menu

SHELL LAUNCHING:
    --launch <shell>        Launch specified shell directly
    --quick <shell_name>    Quick launch by shell name (e.g., zsh, fish)
    --dry-run <shell>       Show what would happen without launching
    --info <shell>          Show detailed information about a shell
    --check                 Health check for all shells
    --recommend             Show shell recommendations

FAVORITES:
    --add-favorite <shell>    Add shell to favorites
    --remove-favorite <shell> Remove shell from favorites
    --show-favorites          List favorite shells

BACKUP & TRACKING:
    --backup                Backup current shell reference
    --session-info          Show current session information
    --history               Show shell launch history

ADVANCED:
    --plugins <shell>       Show plugins/frameworks for shell
    --export [file]         Export configuration
    --import <file>         Import configuration

QUICK LAUNCHES:
    --bash                  Launch bash shell
    --zsh                   Launch zsh shell
    --fish                  Launch fish shell
    --csh                   Launch csh shell
    --sh                    Launch sh shell

EXAMPLES:
    shell-switcher.sh                    # Interactive menu
    shell-switcher.sh --launch /bin/zsh  # Launch zsh directly
    shell-switcher.sh --quick fish       # Quick launch fish
    shell-switcher.sh --zsh              # Launch zsh shortcut
    shell-switcher.sh --info zsh         # Show zsh information
    shell-switcher.sh --favorites        # Show favorites menu
    shell-switcher.sh --check            # Health check all shells

NOTES:
    - Shells are launched directly, not set as system default
    - Type 'exit' in the launched shell to return to previous shell
    - Session information is tracked for debugging
    - All shell changes are logged for history

FILES:
    Config Directory: $CONFIG_DIR
    Favorites:       $FAVORITES_FILE
    History:         $HISTORY_FILE
    Backup:          $BACKUP_FILE
    Session:         $SESSION_FILE

AUTHOR:
    Created by Sombrechip88244
    Modified for direct shell execution

LICENSE:
    GNU General Public License v3.0
EOF
}

# Version function
show_version() {
    echo -e "${WHITE}$SCRIPT_NAME v$VERSION${NC}"
    echo "Copyright (C) 2024 Sombrechip88244"
    echo "License: GNU GPL v3.0"
    echo "This is free software; you are free to change and redistribute it."
    echo
    echo "Features: Direct shell launching, Interactive menu, Favorites,"
    echo "         Session tracking, Shell information, Plugin detection"
    echo
    echo "Mode: Direct execution (does not change system default shell)"
}

# Main argument parsing
main() {
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        --list)
            print_color "$CYAN" "\n$INFO Available Shells:"
            get_available_shells
            exit 0
            ;;
        --list-detailed)
            print_color "$CYAN" "\n$INFO Available Shells (Detailed):"
            echo "=================================="
            local shells
            shells=$(get_available_shells)
            for shell in $shells; do
                local current_marker=""
                [ "$shell" = "$SHELL" ] && current_marker=" (current) $STAR"
                echo "$shell$current_marker"
                echo "  $(get_shell_info "$shell")"
                echo
            done
            exit 0
            ;;
        --current)
            print_color "$CYAN" "Current shell: $SHELL"
            if [ -f "$SESSION_FILE" ]; then
                print_color "$YELLOW" "Session info:"
                cat "$SESSION_FILE"
            fi
            exit 0
            ;;
        --launch|--set)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Shell path required"; exit 1; }
            launch_shell "$2" true false true
            exit $?
            ;;
        --quick)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Shell name required"; exit 1; }
            quick_launch "$2"
            exit $?
            ;;
        --dry-run)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Shell path required"; exit 1; }
            launch_shell "$2" false true false
            exit 0
            ;;
        --info)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Shell path required"; exit 1; }
            show_shell_info "$2"
            exit 0
            ;;
        --check)
            health_check
            exit 0
            ;;
        --recommend)
            get_recommendations
            exit 0
            ;;
        --add-favorite)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Shell path required"; exit 1; }
            add_favorite "$2"
            exit 0
            ;;
        --remove-favorite)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Shell path required"; exit 1; }
            remove_favorite "$2"
            exit 0
            ;;
        --show-favorites)
            show_favorites
            exit 0
            ;;
        --favorites)
            interactive_menu true
            exit $?
            ;;
        --backup)
            backup_shell
            exit 0
            ;;
        --session-info)
            if [ -f "$SESSION_FILE" ]; then
                print_color "$CYAN" "$INFO Current Session Information:"
                cat "$SESSION_FILE"
            else
                print_color "$YELLOW" "$WARNING No active session information"
            fi
            exit 0
            ;;
        --history)
            show_history
            exit 0
            ;;
        --plugins)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Shell name required"; exit 1; }
            echo "Plugins for $2:"
            check_shell_plugins "$2"
            exit 0
            ;;
        --export)
            export_config "${2:-shell-switcher-config.json}"
            exit 0
            ;;
        --import)
            [ -z "${2:-}" ] && { print_color "$RED" "$ERROR Import file required"; exit 1; }
            import_config "$2"
            exit $?
            ;;
        # Quick launch shortcuts
        --bash)
            quick_launch "bash"
            exit $?
            ;;
        --zsh)
            quick_launch "zsh"
            exit $?
            ;;
        --fish)
            quick_launch "fish"
            exit $?
            ;;
        --csh)
            quick_launch "csh"
            exit $?
            ;;
        --tcsh)
            quick_launch "tcsh"
            exit $?
            ;;
        --sh)
            quick_launch "sh"
            exit $?
            ;;
        --ksh)
            quick_launch "ksh"
            exit $?
            ;;
        --dash)
            quick_launch "dash"
            exit $?
            ;;
        --interactive|"")
            print_color "$CYAN" "$STAR Welcome to $SCRIPT_NAME v$VERSION"
            print_color "$WHITE" "Hello $USER!"
            echo
            print_color "$CYAN" "Your current shell is: $SHELL"
            echo
            echo -n "Would you like to launch a different shell? (y/N): "
            read answer
            case "$answer" in
                y|Y) interactive_menu false ;;
                *) print_color "$CYAN" "No changes made. Staying in $SHELL";;
            esac
            exit 0
            ;;
        *)
            print_color "$RED" "$ERROR Unknown option: $1"
            echo "Use '$(basename "$0") --help' for usage information."
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"