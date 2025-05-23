#!/usr/bin/env fish

function render_frame
    # Clear screen and move cursor to top-left
    echo -en "\e[H\e[2J"

    # Draw sparkly title and score
    set_color -o brmagenta
    echo "✨ Snek Game ✨"
    echo (set_color brwhite)"Score: "(set_color bryellow)"$score"(set_color brmagenta)" ✨"
    echo

    # Draw top border with glimmer
    set_color -o blue
    echo -n "╔"
    for i in (seq (math "$GRID_WIDTH * 2"))
        echo -n "═"
    end
    echo "╗"

    # Draw game grid (scaled up horizontally)
    for y in (seq $GRID_HEIGHT)
        set_color -o blue
        echo -n "║"
        for x in (seq $GRID_WIDTH)
            # Check if current position contains snake
            if contains "$x,$y" $snake_segments
                # Snake head
                if test "$x" = "$snake_x" -a "$y" = "$snake_y"
                    set_color -o brgreen
                    echo -n "🟢"
                else
                    # Snake body with gradient effect
                    set_color -o green
                    echo -n "██"
                end
            # Check if current position contains food
            else if test $x = $food_x -a $y = $food_y
                set_color -o brred
                echo -n "🍎"
            else
                set_color -o blue
                echo -n "  "
            end
        end
        set_color -o blue
        echo "║"
    end

    # Draw bottom border with glimmer
    set_color -o blue
    echo -n "╚"
    for i in (seq (math "$GRID_WIDTH * 2"))
        echo -n "═"
    end
    echo "╝"

    # Show controls with sparkles
    echo
    set_color brmagenta
    echo "✨ Controls ✨"
    set_color brwhite
    echo "W/A/S/D: Move  Q: Quit"

    # Reset colors
    set_color normal
end
