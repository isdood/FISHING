#!/usr/bin/env fish

function start_game_loop
    while test "$game_running" = true
        # Draw current frame
        render_frame

        # Non-blocking input check
        check_input

        # Update game state
        update_game_state

        # Control game speed
        sleep 0.1
    end
end

function update_game_state
    # Calculate new position
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

    # Check wall collisions
    if test $new_x -lt 1 -o $new_x -gt $GRID_WIDTH -o \
           $new_y -lt 1 -o $new_y -gt $GRID_HEIGHT
        set -g game_running false
        game_over
        return
    end

    # Check self collisions
    if contains "$new_x,$new_y" $snake_segments
        set -g game_running false
        game_over
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
    else
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
