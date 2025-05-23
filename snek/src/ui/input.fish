#!/usr/bin/env fish

function check_input
    # Try to read a single character with no buffering
    read -n 1 -l input 2>/dev/null

    if test $status -eq 0; and test -n "$input"
        # Store current direction before any changes
        set -l current_dir $direction

        switch "$input"
            case q Q
                set -g game_running false
                return

            case w W
                # Only allow up if not currently moving down
                if test "$current_dir" != "down"
                    set -g direction "up"
                    echo "⬆️ Moving up" > /dev/tty
                end

            case s S
                # Only allow down if not currently moving up
                if test "$current_dir" != "up"
                    set -g direction "down"
                    echo "⬇️ Moving down" > /dev/tty
                end

            case a A
                # Only allow left if not currently moving right
                if test "$current_dir" != "right"
                    set -g direction "left"
                    echo "⬅️ Moving left" > /dev/tty
                end

            case d D
                # Only allow right if not currently moving left
                if test "$current_dir" != "left"
                    set -g direction "right"
                    echo "➡️ Moving right" > /dev/tty
                end
        end
    end
end
