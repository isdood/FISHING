#!/usr/bin/env fish

function fish-git
    # Check if a commit message was provided
    if test (count $argv) -eq 0
        echo "🌟 Error: Please provide a commit message"
        return 1
    end

    # Try normal git add first
    if not git add .
        echo "✨ Attempting to use sudo for git add..."

        # Ask for sudo password securely
        read -s -P "🔐 Please enter sudo password: " sudo_pass
        echo # Add a newline after password input

        # Use sudo with password from stdin
        if not echo $sudo_pass | sudo -S git add .
            echo "❌ Error: Failed to add files even with sudo"
            set sudo_pass "" # Clear the password variable
            return 1
        end
        set sudo_pass "" # Clear the password variable
    end

    # Execute remaining git commands
    if not git commit -m "$argv"
        echo "❌ Error: Failed to commit changes"
        return 1
    end

    if not git push
        echo "❌ Error: Failed to push changes"
        return 1
    end

    echo "✨ Successfully completed all git operations! ✨"
end
