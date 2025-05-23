#!/usr/bin/env fish

function check_input
    # Read a single character without blocking
    read -n 1 -t 0 key

    # Debug: Show current key press and direction
    if test -n "$key"
        echo "🎮 Key pressed: $key (Current direction: $direction)" > /dev/tty
    end

    # Store current direction before changing
    set -l new_direction $direction

    switch $key
        case q Q
            set -g game_running false
        case w W
            if test "$direction" != "down"
                set new_direction "up"
                echo "⬆️ Changing direction to up" > /dev/tty
            end
        case s S
            if test "$direction" != "up"
                set new_direction "down"
                echo "⬇️ Changing direction to down" > /dev/tty
            end
        case a A
            if test "$direction" != "right"
                set new_direction "left"
                echo "⬅️ Changing direction to left" > /dev/tty
            end
        case d D
            if test "$direction" != "left"
                set new_direction "right"
                echo "➡️ Changing direction to right" > /dev/tty
            end
    end

    # Update global direction with debug output
    if test "$new_direction" != "$direction"
        set -g direction $new_direction
        echo "🔄 Direction updated to: $direction" > /dev/tty
    end
end
