#!/usr/bin/env fish

function start_game_loop
    while test "$game_running" = true
        # Clear input buffer before checking for new input
        read -l -t 0

        # Check for input first
        check_input

        # Debug: Show current game state
        echo "🎮 Game State:" > /dev/tty
        echo "  🐍 Position: ($snake_x,$snake_y)" > /dev/tty
        echo "  👆 Direction: $direction" > /dev/tty
        echo "  🎯 Score: $score" > /dev/tty

        # Update game state
        update_game_state

        # Render current frame
        render_frame

        # Small delay for game speed
        sleep 0.15
    end
end

function update_game_state
    # Store current position
    set -l new_x $snake_x
    set -l new_y $snake_y

    # Debug: Show pre-movement state
    echo "📍 Pre-movement:" > /dev/tty
    echo "  Position: ($new_x,$new_y)" > /dev/tty
    echo "  Direction: $direction" > /dev/tty

    # Update position based on direction
    switch $direction
        case "up"
            set new_y (math "$new_y - 1")
            echo "⬆️ Moving up" > /dev/tty
        case "down"
            set new_y (math "$new_y + 1")
            echo "⬇️ Moving down" > /dev/tty
        case "left"
            set new_x (math "$new_x - 1")
            echo "⬅️ Moving left" > /dev/tty
        case "right"
            set new_x (math "$new_x + 1")
            echo "➡️ Moving right" > /dev/tty
    end

    # Debug: Show post-movement calculation
    echo "📍 Post-movement calculation:" > /dev/tty
    echo "  New position will be: ($new_x,$new_y)" > /dev/tty

    # Check for collisions with walls
    if test $new_x -lt 1 -o $new_x -gt $GRID_WIDTH -o \
           $new_y -lt 1 -o $new_y -gt $GRID_HEIGHT
        echo "💥 Wall collision detected!" > /dev/tty
        set -g game_running false
        game_over
        return
    end

    # Update position
    set -g snake_x $new_x
    set -g snake_y $new_y

    # Update segments
    set -p snake_segments "$snake_x,$snake_y"

    # Check for food
    if test $snake_x = $food_x -a $snake_y = $food_y
        set -g score (math "$score + 1")
        echo "🍎 Food eaten! New score: $score" > /dev/tty
        spawn_food
    else
        set -e snake_segments[-1]
    end
end
