#!/usr/bin/env fish

function check_input
    # Read a single character immediately
    read -n 1 key

    # Store current direction before changing
    set -l new_direction $direction

    switch "$key"
        case \177 q Q # 177 is backspace/delete
            echo "🚪 Quitting game..." > /dev/tty
            set -g game_running false
            return

        case w W A
            if test "$direction" != "down"
                set new_direction "up"
                echo "⬆️ Direction changed to up" > /dev/tty
            end

        case s S B
            if test "$direction" != "up"
                set new_direction "down"
                echo "⬇️ Direction changed to down" > /dev/tty
            end

        case a A D
            if test "$direction" != "right"
                set new_direction "left"
                echo "⬅️ Direction changed to left" > /dev/tty
            end

        case d D C
            if test "$direction" != "left"
                set new_direction "right"
                echo "➡️ Direction changed to right" > /dev/tty
            end
    end

    if test "$new_direction" != "$direction"
        set -g direction $new_direction
    end
end
