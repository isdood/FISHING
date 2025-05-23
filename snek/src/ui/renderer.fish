#!/usr/bin/env fish

function render_frame
    # Clear screen and move cursor to top-left
    echo -en "\e[H\e[2J"

    # Draw title and score with extra GLIMMER ✨
    set_color -o brmagenta
    echo -n "✨ "
    set_color -o brwhite
    echo -n "Snek Game"
    set_color -o brmagenta
    echo " ✨"

    set_color brwhite
    echo -n "Score: "
    set_color bryellow
    echo -n "$score"
    set_color brmagenta
    echo " ✨"
    echo

    # Draw top border with consistent spacing
    set_color -o blue
    echo -n "╔"
    for i in (seq $GRID_WIDTH)
        echo -n "══"
    end
    echo "╗"

    # Draw game grid
    for y in (seq $GRID_HEIGHT)
        # Left border
        set_color -o blue
        echo -n "║"

        # Grid contents
        for x in (seq $GRID_WIDTH)
            if contains "$x,$y" $snake_segments
                if test "$x" = "$snake_x"; and test "$y" = "$snake_y"
                    # Snake head with GLIMMER
                    set_color -o brgreen
                    echo -n "🟢"
                else
                    # Snake body segments
                    set_color -o green
                    echo -n "██"
                end
            else if test "$x" = "$food_x"; and test "$y" = "$food_y"
                # Food with extra sparkle
                set_color -o brred
                echo -n "🍎"
            else
                # Empty space
                echo -n "  "
            end
        end

        # Right border
        set_color -o blue
        echo "║"
    end

    # Draw bottom border
    set_color -o blue
    echo -n "╚"
    for i in (seq $GRID_WIDTH)
        echo -n "══"
    end
    echo "╝"

    # Show controls with extra GLIMMER
    echo
    set_color brmagenta
    echo "✨ Controls ✨"
    set_color brwhite
    echo "W/A/S/D: Move  Q: Quit"

    # Reset colors
    set_color normal
end
