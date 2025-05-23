#!/usr/bin/env fish

function start_game_loop
    while test "$game_running" = true
        # Clear any pending input
        while read -l -t 0
            read -l >/dev/null
        end

        # Render current state
        render_frame

        # Check for input
        check_input

        # Update game state
        update_game_state

        # Small delay for game speed
        sleep 0.1
    end
end

function update_game_state
    # Calculate new head position based on direction
    set -l new_x $snake_x
    set -l new_y $snake_y

    switch $direction
        case "up"
            set new_y (math "$snake_y - 1")
        case "down"
            set new_y (math "$snake_y + 1")
        case "left"
            set new_x (math "$snake_x - 1")
        case "right"
            set new_x (math "$snake_x + 1")
    end

    # Debug movement
    echo "🎯 Moving $direction from ($snake_x,$snake_y) to ($new_x,$new_y)" > /dev/tty

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
    if test "$snake_x" = "$food_x"; and test "$snake_y" = "$food_y"
        set -g score (math "$score + 1")
        spawn_food
    else
        set -e snake_segments[-1]
    end
end
