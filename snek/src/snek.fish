#!/usr/bin/env fish

# 🌟 Snek Game Main File
# Created by: isdood
# Date: 2025-05-23 13:51:51

function cleanup_terminal
    # Restore terminal settings
    stty $ORIGINAL_STTY
    echo -en "\e[?25h" # Show cursor
    clear
end

function spawn_food
    set -g food_x (random 1 $GRID_WIDTH)
    set -g food_y (random 1 $GRID_HEIGHT)
    echo "🍎 Spawned food at ($food_x,$food_y)" > /dev/tty

    while contains "$food_x,$food_y" $snake_segments
        set -g food_x (random 1 $GRID_WIDTH)
        set -g food_y (random 1 $GRID_HEIGHT)
        echo "🔄 Respawned food at ($food_x,$food_y)" > /dev/tty
    end
end

function init_game
    echo "🎮 Initializing game..." > /dev/tty

    # Save original terminal settings
    set -g ORIGINAL_STTY (stty -g)

    # Configure terminal for immediate input without echo
    stty raw -echo

    # Set up initial game state
    set -g GRID_WIDTH 20
    set -g GRID_HEIGHT 10

    # Initial snake position (middle of grid)
    set -g snake_x (math "floor($GRID_WIDTH/2)")
    set -g snake_y (math "floor($GRID_HEIGHT/2)")

    # Initial direction (right)
    set -g direction "right"
    echo "🎯 Initial direction set to: $direction" > /dev/tty

    # Initialize snake segments
    set -g snake_segments
    for i in (seq 3)
        set -p snake_segments (math "$snake_x - $i + 1")","$snake_y
    end

    # Game state
    set -g game_running true
    set -g score 0

    # Initialize food position
    spawn_food

    echo "✨ Game initialized!" > /dev/tty

    # Clear screen before starting
    clear
end

# Source our other files
source (dirname (status filename))/engine/game_loop.fish
source (dirname (status filename))/ui/renderer.fish
source (dirname (status filename))/ui/input.fish

# Set up cleanup on exit
function on_exit --on-event fish_exit
    cleanup_terminal
end

# Start the game
init_game
start_game_loop
cleanup_terminal
