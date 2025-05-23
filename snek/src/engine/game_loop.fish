#!/usr/bin/env fish

function start_game_loop
    # Initialize movement timer
    set -g move_delay 0.2  # Seconds between moves
    set -g last_move (date +%s%N)  # Get nanoseconds for more precise timing

    while test "$game_running" = true
        # Get current time in nanoseconds
        set -l current_time (date +%s%N)

        # Check if it's time to move (convert nanoseconds to seconds)
        set -l time_diff (math "($current_time - $last_move) / 1000000000")

        # Always render and check input
        render_frame
        check_input

        # Move snake if enough time has passed
        if test (math "$time_diff >= $move_delay") = 1
            update_game_state
            set -g last_move $current_time
        end

        # Small delay to prevent CPU overuse
        sleep 0.05
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

    # Check wall collisions with extra GLIMMER ✨
    if test $new_x -lt 1 -o $new_x -gt $GRID_WIDTH -o \
           $new_y -lt 1 -o $new_y -gt $GRID_HEIGHT
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

    # Handle food with extra sparkle ✨
    if test "$snake_x" = "$food_x"; and test "$snake_y" = "$food_y"
        set -g score (math "$score + 1")
        spawn_food
        # Speed up slightly
        set -g move_delay (math "max(0.05, $move_delay * 0.95)")
    else
        set -e snake_segments[-1]
    end
end
