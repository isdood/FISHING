#!/usr/bin/env fish

function start_game_loop
    while test "$game_running" = true
        # Update game state
        update_game_state

        # Render current frame
        render_frame

        # Check for input (non-blocking)
        check_input

        # Control game speed
        sleep 0.1
    end
end

function update_game_state
    # Store previous position
    set -l prev_x $snake_x
    set -l prev_y $snake_y

    # Update head position based on direction
    switch $direction
        case "up"
            set snake_y (math "$snake_y - 1")
        case "down"
            set snake_y (math "$snake_y + 1")
        case "left"
            set snake_x (math "$snake_x - 1")
        case "right"
            set snake_x (math "$snake_x + 1")
    end

    # Check for collisions with walls
    if test $snake_x -lt 1 -o $snake_x -gt $GRID_WIDTH -o \
           $snake_y -lt 1 -o $snake_y -gt $GRID_HEIGHT
        set game_running false
        return
    end

    # Update snake segments
    set -l new_segments "$snake_x,$snake_y"
    for segment in $snake_segments[1..-2]
        set -a new_segments $segment
    end
    set snake_segments $new_segments

    # Check if food was eaten
    if test $snake_x = $food_x -a $snake_y = $food_y
        set score (math "$score + 1")
        set -a snake_segments $snake_segments[-1]
        spawn_food
    end
end
