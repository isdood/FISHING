#!/usr/bin/env fish

function check_input
    # Read a single character without blocking
    read -n 1 -t 0 key

    # Store current direction before changing
    set -l new_direction $direction

    switch $key
        case q Q
            set -g game_running false
        case w W
            # Only allow up if not moving down
            if test "$direction" != "down"
                set new_direction "up"
            end
        case s S
            # Only allow down if not moving up
            if test "$direction" != "up"
                set new_direction "down"
            end
        case a A
            # Only allow left if not moving right
            if test "$direction" != "right"
                set new_direction "left"
            end
        case d D
            # Only allow right if not moving left
            if test "$direction" != "left"
                set new_direction "right"
            end
    end

    # Update global direction
    set -g direction $new_direction
end
