#!/bin/bash
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