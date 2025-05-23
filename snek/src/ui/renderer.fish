#!/usr/bin/env fish

function render_frame
    # Clear screen and move cursor to top-left
    echo -en "\e[H\e[2J"

    # Draw top border with glimmering effect
    set_color -o brmagenta
    echo "✨ Score: $score ✨"
    echo

    # Draw game grid
    for y in (seq $GRID_HEIGHT)
        for x in (seq $GRID_WIDTH)
            # Check if current position contains snake
            if contains "$x,$y" $snake_segments
                set_color -o brgreen
                echo -n "█"
            # Check if current position contains food
            else if test $x = $food_x -a $y = $food_y
                set_color -o brred
                echo -n "●"
            else
                set_color -o blue
                echo -n "·"
            end
        end
        echo # New line after each row
    end

    # Reset colors
    set_color normal
end
