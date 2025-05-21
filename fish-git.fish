#!/usr/bin/env fish

function fish-git
    # Check if a commit message was provided
    if test (count $argv) -eq 0
        echo "Error: Please provide a commit message"
        return 1
    end

    # Execute git commands
    git add .
    git commit -m "$argv"
    git push
end
