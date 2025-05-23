#!/usr/bin/env fish

function start_game_loop
    # Initialize movement timer
    set -g move_delay 0.2  # Seconds between moves
    set -g last_move (date +%s)
    set -g next_move $last_move

    while test "$game_running" = true
        # Get current time
        set -l current_time (date +%s)

        # Always check input first
        check_input

        # Update position if enough time has passed
        if test "$current_time" -ge "$next_move"
            update_game_state
            set -g last_move $current_time
            set -g next_move (math "$current_time + 1")
        end

        # Always render after updates
        render_frame

        # Smaller sleep to stay responsive
        sleep 0.05
    end
end

function update_game_state
    begin
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

        # Validate new position before updating
        if begin
            test $new_x -ge 1; and \
            test $new_x -le $GRID_WIDTH; and \
            test $new_y -ge 1; and \
            test $new_y -le $GRID_HEIGHT
        end
            # Check self collision
            if contains "$new_x,$new_y" $snake_segments
                set -g game_running false
                game_over "✨ Oops! You bit yourself! ✨"
                return 1
            end

            # Update position
            set -g snake_x $new_x
            set -g snake_y $new_y
            set -p snake_segments "$snake_x,$snake_y"

            # Handle food
            if test "$snake_x" = "$food_x"; and test "$snake_y" = "$food_y"
                set -g score (math "$score + 1")
                spawn_food
                # Speed up slightly
                set -g move_delay (math "max(0.05, $move_delay * 0.95)")
            else
                set -e snake_segments[-1]
            end
        else
            # Hit wall
            set -g game_running false
            game_over "✨ Bonk! You hit a wall! ✨"
            return 1
        end
    end
end

function game_over
    echo -en "\e[H\e[2J" # Clear screen
    set_color -o brmagenta
    echo "
    ✨✨✨✨✨✨✨✨✨✨✨✨✨
    ✨      Game Over!       ✨
    ✨     Score: $score     ✨
    ✨ $argv[1] ✨
    ✨✨✨✨✨✨✨✨✨✨✨✨✨
    "
    sleep 2
end
