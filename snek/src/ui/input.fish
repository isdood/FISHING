#!/usr/bin/env fish

function check_input
    # Non-blocking read
    read -n 1 -l input 2>/dev/null

    if test $status -eq 0; and test -n "$input"
        # Process input immediately
        switch "$input"
            case q Q
                set -g game_running false
                return

            case w W
                if test "$direction" != "down"
                    set -g direction "up"
                end

            case s S
                if test "$direction" != "up"
                    set -g direction "down"
                end

            case a A
                if test "$direction" != "right"
                    set -g direction "left"
                end

            case d D
                if test "$direction" != "left"
                    set -g direction "right"
                end
        end
    end
end
