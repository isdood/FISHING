#!/usr/bin/env fish

function check_input
    # Debug: Show we're checking for input
    echo "👀 Checking for input..." > /dev/tty

    # Try to read input without blocking
    read -l -n 1 -t 0 key

    # Debug: Show raw input received
    echo "📝 Raw input received: '$key'" > /dev/tty

    # Store current direction before changing
    set -l new_direction $direction
    echo "🎯 Current direction: $direction" > /dev/tty

    # Process key press
    switch "$key"
        case q Q
            echo "🚪 Quit key pressed" > /dev/tty
            set -g game_running false

        case w W
            echo "⬆️ Up key pressed" > /dev/tty
            if test "$direction" != "down"
                set new_direction "up"
            end

        case s S
            echo "⬇️ Down key pressed" > /dev/tty
            if test "$direction" != "up"
                set new_direction "down"
            end

        case a A
            echo "⬅️ Left key pressed" > /dev/tty
            if test "$direction" != "right"
                set new_direction "left"
            end

        case d D
            echo "➡️ Right key pressed" > /dev/tty
            if test "$direction" != "left"
                set new_direction "right"
            end
    end

    # Debug: Show direction change
    if test "$new_direction" != "$direction"
        echo "🔄 Direction changing from $direction to $new_direction" > /dev/tty
        set -g direction $new_direction
    end
end
