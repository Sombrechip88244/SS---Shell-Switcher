#!/bin/bash

# Version information
VERSION="1.0.1"
SCRIPT_NAME="Shell Switcher"

# Function to display help
show_help() {
    cat << EOF
$SCRIPT_NAME v$VERSION

DESCRIPTION:
    A simple shell switcher written in bash that allows you to easily change
    your default shell on Unix-like systems.

USAGE:
    $(basename "$0") [OPTION]

OPTIONS:
    -h, --help      Show this help message and exit
    -v, --version   Show version information and exit
    --list          List all available shells
    --current       Show current shell only

EXAMPLES:
    $(basename "$0")              # Run interactively
    $(basename "$0") --help       # Show this help
    $(basename "$0") --version    # Show version
    $(basename "$0") --list       # List available shells
    $(basename "$0") --current    # Show current shell

AUTHOR:
    Created by Sombrechip88244
    GitHub: https://github.com/Sombrechip88244/SS---Shell-Switcher

LICENSE:
    This program is licensed under the GNU General Public License v3.0
EOF
}

# Function to display version
show_version() {
    echo "$SCRIPT_NAME v$VERSION"
    echo "Copyright (C) 2024 Sombrechip88244"
    echo "License: GNU GPL v3.0"
    echo "This is free software; you are free to change and redistribute it."
}

# Function to list available shells
list_shells() {
    echo "Available shells on this system:"
    if [[ -f /etc/shells ]]; then
        cat /etc/shells | grep -v '^#' | grep -v '^$'
    else
        echo "Error: /etc/shells file not found"
        exit 1
    fi
}

# Function to show current shell
show_current() {
    echo "Your current shell is: $SHELL"
}

# Parse command line arguments
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        show_version
        exit 0
        ;;
    --list)
        list_shells
        exit 0
        ;;
    --current)
        show_current
        exit 0
        ;;
    "")
        # No arguments - run interactive mode
        ;;
    *)
        echo "Error: Unknown option '$1'"
        echo "Use '$(basename "$0") --help' for usage information."
        exit 1
        ;;
esac

# Original interactive functionality
echo "Hello" $USER
sleep 0.3
echo "-------------------------------------------------------------"
sleep 0.3
echo "Your current shell is " $SHELL
sleep 0.3
read -p "Would you like to change shell? (yes/no): " Would_you_like_to_change_shell

if [[ $Would_you_like_to_change_shell = "yes" ]]
then
    echo "You have selected yes - These are your options"
    echo "Available shells:"
    cat /etc/shells
    echo ""
    read -p "Enter the path of your preferred shell: " new_shell
    if [[ -f $new_shell ]]; then
        echo "Attempting to change shell to $new_shell..."
        if chsh -s $new_shell; then
            echo "Shell successfully changed to $new_shell"
            echo "Please log out and log back in for changes to take effect."
        else
            echo "Failed to change shell. Try running with sudo:"
            echo "sudo chsh -s $new_shell $USER"
            echo "Or use System Preferences > Users & Groups > Advanced Options"
        fi
    else
        echo "Invalid shell path: $new_shell"
    fi
else
    echo "No changes made. Your shell remains $SHELL"
fi