#!/usr/bin/env fish

function start_game_loop
    # Initialize movement timer
    set -g move_delay 0.2  # Seconds between moves
    set -g last_move (date +%s)

    while test "$game_running" = true
        # Get current time
        set -l current_time (date +%s)

        # Calculate time difference properly
        set -l time_diff (math "$current_time - $last_move")

        # Always render and check input
        render_frame
        check_input

        # Move snake on timer using proper fish comparison
        if test "$time_diff" -ge 1
            update_game_state
            set -g last_move $current_time
        end

        # Small delay to prevent CPU overuse
        sleep $move_delay
    end
end

function update_game_state
    # Calculate new position based on current direction
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

    # Check wall collisions using proper fish comparisons
    if begin; test $new_x -lt 1; or test $new_x -gt $GRID_WIDTH; or \
              test $new_y -lt 1; or test $new_y -gt $GRID_HEIGHT; end
        set -g game_running false
        game_over "✨ Bonk! You hit a wall! ✨"
        return
    end

    # Check self collisions
    if contains "$new_x,$new_y" $snake_segments
        set -g game_running false
        game_over "✨ Oops! You bit yourself! ✨"
        return
    end

    # Update position
    set -g snake_x $new_x
    set -g snake_y $new_y
    set -p snake_segments "$snake_x,$snake_y"

    # Handle food
    if test "$snake_x" = "$food_x"; and test "$snake_y" = "$food_y"
        set -g score (math "$score + 1")
        spawn_food
        # Speed up slightly with proper math
        set -g move_delay (math "max(0.05, $move_delay * 0.95)")
    else
        set -e snake_segments[-1]
    end
end
