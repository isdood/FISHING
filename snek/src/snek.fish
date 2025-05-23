#!/usr/bin/env fish

# Source required files
source (dirname (status filename))/engine/game_loop.fish
source (dirname (status filename))/ui/renderer.fish
source (dirname (status filename))/ui/input.fish

function init_game
    echo "🎮 Initializing game..." > /dev/tty

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

    # Initialize food
    spawn_food

    echo "✨ Game initialized!" > /dev/tty
end

# Initialize and start game
clear
echo -en "\e[?25l" # Hide cursor
init_game
start_game_loop
echo -en "\e[?25h" # Show cursor
