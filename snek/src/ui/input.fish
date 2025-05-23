#!/usr/bin/env fish

function check_input
    # Try to read a single character
    read -n 1 -l input 2>/dev/null

    # Only process if we got input
    if test $status -eq 0; and test -n "$input"
        set -l new_direction $direction

        switch "$input"
            case q Q
                set -g game_running false
                return

            case w W
                test "$direction" != "down"; and set new_direction "up"

            case s S
                test "$direction" != "up"; and set new_direction "down"

            case a A
                test "$direction" != "right"; and set new_direction "left"

            case d D
                test "$direction" != "left"; and set new_direction "right"
        end

        # Update direction if changed
        test "$new_direction" != "$direction"; and set -g direction $new_direction
    end
end
