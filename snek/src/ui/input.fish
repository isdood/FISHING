#!/usr/bin/env fish

function check_input
    # Read a single character without echo
    read -n 1 -l input </dev/tty >/dev/null 2>&1

    if test $status -eq 0
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
        if test "$new_direction" != "$direction"
            set -g direction $new_direction
        end
    end
end
