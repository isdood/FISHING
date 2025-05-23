#!/usr/bin/env fish

function start_game_loop
    while test "$game_running" = true
        set -l current_time (date +%s)

        # Always render current state
        render_frame

        # Check for input (non-blocking)
        check_input

        # Move snake automatically if enough time has passed
        if test (math "$current_time - $last_update") -ge 1
            update_game_state
            set -g last_update $current_time
        end

        # Small delay for CPU
        sleep 0.05
    end
end

function update_game_state
    # Calculate new head position
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

    # Wall collision check
    if begin
        test $new_x -lt 1; or \
        test $new_x -gt $GRID_WIDTH; or \
        test $new_y -lt 1; or \
        test $new_y -gt $GRID_HEIGHT
    end
        set -g game_running false
        game_over "✨ Bonk! Wall collision! ✨"
        return
    end

    # Self collision check
    if contains "$new_x,$new_y" $snake_segments
        set -g game_running false
        game_over "✨ Oops! Self bite! ✨"
        return
    end

    # Update position
    set -g snake_x $new_x
    set -g snake_y $new_y
    set -p snake_segments "$snake_x,$snake_y"

    # Food check
    if test "$snake_x" = "$food_x"; and test "$snake_y" = "$food_y"
        set -g score (math "$score + 1")
        spawn_food
        # Speed up!
        set -g move_timer (math "max(0.05, $move_timer * 0.95)")
    else
        set -e snake_segments[-1]
    end
end
