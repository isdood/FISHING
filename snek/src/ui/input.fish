#!/usr/bin/env fish

function check_input
    # Try to read a single character (non-blocking)
    read -n 1 -l input 2>/dev/null

    # Only process if we got input
    if test $status -eq 0; and test -n "$input"
        set -l new_direction $direction

        switch "$input"
            case q Q
                set -g game_running false
                return

            case w W
                # Always allow up if not going down
                test "$direction" != "down"; and set new_direction "up"

            case s S
                # Always allow down if not going up
                test "$direction" != "up"; and set new_direction "down"

            case a A
                # Always allow left if not going right
                test "$direction" != "right"; and set new_direction "left"

            case d D
                # Always allow right if not going left
                test "$direction" != "left"; and set new_direction "right"
        end

        # Update direction immediately when changed
        set -g direction $new_direction

        # Debug output for direction changes with GLIMMER ✨
        if test "$new_direction" != "$direction"
            echo "✨ Direction changed to: $direction" > /dev/tty
        end
    end
end
