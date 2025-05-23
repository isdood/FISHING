#!/usr/bin/env fish

function start_game_loop
    while test "$game_running" = true
        # Debug: Show current snake state
        echo "🐍 Snake position: $snake_x,$snake_y (Direction: $direction)" > /dev/tty

        # Update game state
        update_game_state

        # Render current frame
        render_frame

        # Check for input (non-blocking)
        check_input

        # Control game speed
        sleep 0.15
    end
end

function update_game_state
    # Calculate new head position based on direction
    set -l new_x $snake_x
    set -l new_y $snake_y

    # Debug: Show movement calculation
    echo "📍 Calculating movement from ($snake_x,$snake_y) going $direction" > /dev/tty

    switch $direction
        case "up"
            set new_y (math "$snake_y - 1")
            echo "⬆️ Moving up to ($new_x,$new_y)" > /dev/tty
        case "down"
            set new_y (math "$snake_y + 1")
            echo "⬇️ Moving down to ($new_x,$new_y)" > /dev/tty
        case "left"
            set new_x (math "$snake_x - 1")
            echo "⬅️ Moving left to ($new_x,$new_y)" > /dev/tty
        case "right"
            set new_x (math "$snake_x + 1")
            echo "➡️ Moving right to ($new_x,$new_y)" > /dev/tty
    end

    # Check for collisions with walls
    if test $new_x -lt 1 -o $new_x -gt $GRID_WIDTH -o \
           $new_y -lt 1 -o $new_y -gt $GRID_HEIGHT
        set -g game_running false
        game_over
        return
    end

    # Check for collision with self
    if contains "$new_x,$new_y" $snake_segments
        set -g game_running false
        game_over
        return
    end

    # Update head position
    set -g snake_x $new_x
    set -g snake_y $new_y

    # Add new head position to segments
    set -p snake_segments "$snake_x,$snake_y"

    # Remove tail unless food was eaten
    if test $snake_x = $food_x -a $snake_y = $food_y
        set -g score (math "$score + 1")
        spawn_food
        echo "🍎 Food eaten! Score: $score" > /dev/tty
    else
        # Remove the last segment (tail)
        set -e snake_segments[-1]
    end
end

function game_over
    echo -en "\e[H\e[2J" # Clear screen
    set_color -o brmagenta
    echo "
    ✨✨✨✨✨✨✨✨✨✨
    ✨  Game Over!  ✨
    ✨ Score: $score ✨
    ✨✨✨✨✨✨✨✨✨✨
    "
    sleep 2
end
