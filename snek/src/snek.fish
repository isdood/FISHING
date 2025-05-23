#!/usr/bin/env fish

# 🌟 Snek Game Main File
# Created by: isdood
# Date: 2025-05-23

source (dirname (status filename))/engine/game_loop.fish
source (dirname (status filename))/ui/renderer.fish
source (dirname (status filename))/ui/input.fish

function init_game
    # Set up initial game state
    set -g GRID_WIDTH 20
    set -g GRID_HEIGHT 10

    # Initial snake position (middle of grid)
    set -g snake_x (math "floor($GRID_WIDTH/2)")
    set -g snake_y (math "floor($GRID_HEIGHT/2)")

    # Initial direction (right)
    set -g direction "right"

    # Snake body segments (starts with length 3)
    set -g snake_segments
    for i in (seq 3)
        set -a snake_segments "$snake_x",(math "$snake_y")
    end

    # Game state
    set -g game_running true
    set -g score 0

    # Initialize food position
    spawn_food
end

function spawn_food
    # Simple food spawning (random position)
    set -g food_x (random 1 $GRID_WIDTH)
    set -g food_y (random 1 $GRID_HEIGHT)
end

# Clear screen and start game
clear
echo -en "\e[?25l" # Hide cursor
init_game
start_game_loop

# Clean up on exit
echo -en "\e[?25h" # Show cursor
