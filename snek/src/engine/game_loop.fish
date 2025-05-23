#!/usr/bin/env fish

function start_game_loop
    # Track time for movement
    set -g last_move 0
    set -g move_interval 0.2  # Seconds between automatic movements

    while test "$game_running" = true
        # Get current time
        set -l current_time (date +%s.%N)

        # Draw current frame
        render_frame

        # Check for input (non-blocking)
        check_input

        # Check if it's time to move
        set -l time_diff (math "$current_time - $last_move")
        if test (math "$time_diff >= $move_interval") = 1
            # Update game state (automatic movement)
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

    # Check wall collisions with extra GLIMMER
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

    # Handle food with extra sparkle
    if test "$snake_x" = "$food_x"; and test "$snake_y" = "$food_y"
        set -g score (math "$score + 1")
        spawn_food
        # Speed up slightly with each food eaten
        set -g move_interval (math "max(0.05, $move_interval * 0.95)")
    else
        set -e snake_segments[-1]
    end
end

function game_over
    set -l message $argv[1]
    echo -en "\e[H\e[2J" # Clear screen
    set_color -o brmagenta
    echo "
    ✨✨✨✨✨✨✨✨✨✨✨✨✨✨
    ✨     Game Over!      ✨
    ✨    Score: $score    ✨
    ✨  $message  ✨
    ✨✨✨✨✨✨✨✨✨✨✨✨✨✨
    "
    sleep 2
end
