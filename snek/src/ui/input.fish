#!/usr/bin/env fish

function check_input
    # Try to read a single character
    read -n 1 -l input 2>/dev/null

    # Only process if we got input
    if test $status -eq 0; and test -n "$input"
        switch "$input"
            case q Q
                set -g game_running false
                return

            case w W
                # Use proper fish test syntax
                if not test "$direction" = "down"
                    set -g direction "up"
                end

            case s S
                if not test "$direction" = "up"
                    set -g direction "down"
                end

            case a A
                if not test "$direction" = "right"
                    set -g direction "left"
                end

            case d D
                if not test "$direction" = "left"
                    set -g direction "right"
                end
        end
    end
end
