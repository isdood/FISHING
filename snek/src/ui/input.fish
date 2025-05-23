#!/usr/bin/env fish

function check_input
    # Read a single character without blocking
    read -n 1 -t 0 key

    switch $key
        case q Q
            set game_running false
        case w W
            test $direction != "down"; and set direction "up"
        case s S
            test $direction != "up"; and set direction "down"
        case a A
            test $direction != "right"; and set direction "left"
        case d D
            test $direction != "left"; and set direction "right"
    end
end
