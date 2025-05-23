#!/usr/bin/env fish

# 🌟 Snek Game Main File
# Created by: isdood
# Date: 2025-05-23

# Debug output
echo "✨ Starting Snek Game..."

# Ensure we're in the correct directory
set -l SCRIPT_DIR (dirname (status filename))
cd $SCRIPT_DIR

# Debug: Show current directory and files
echo "📂 Current directory: "(pwd)
echo "📁 Checking for required files..."

# Check for required files
for file in engine/game_loop.fish ui/renderer.fish ui/input.fish
    if test -f $file
        echo "✓ Found $file"
    else
        echo "❌ Missing required file: $file"
        exit 1
    end
end

# Source required files with error checking
for file in engine/game_loop.fish ui/renderer.fish ui/input.fish
    echo "📥 Loading $file..."
    if not source $file
        echo "❌ Failed to load $file"
        exit 1
    end
end

function init_game
    echo "🎮 Initializing game..."

    # Set up initial game state
    set -g GRID_WIDTH 20
    set -g GRID_HEIGHT 10

    # Initial snake position (middle of grid)
    set -g snake_x (math "floor($GRID_WIDTH/2)")
    set -g snake_y (math "floor($GRID_HEIGHT/2)")

    # Initial direction (right)
    set -g direction "right"

    # Initialize empty snake segments array
    set -g snake_segments

    # Create initial snake body (length 3)
    for i in (seq 3)
        # Add segments to the left of the head
        set -p snake_segments (math "$snake_x - $i + 1")","$snake_y
    end

    # Game state
    set -g game_running true
    set -g score 0

    # Initialize food position
    spawn_food

    echo "✨ Game initialized!"
end

function spawn_food
    # Simple food spawning (random position)
    set -g food_x (random 1 $GRID_WIDTH)
    set -g food_y (random 1 $GRID_HEIGHT)

    # Ensure food doesn't spawn on snake
    while contains "$food_x,$food_y" $snake_segments
        set -g food_x (random 1 $GRID_WIDTH)
        set -g food_y (random 1 $GRID_HEIGHT)
    end
end

# Ensure files are executable
chmod +x engine/game_loop.fish ui/renderer.fish ui/input.fish

# Clear screen and hide cursor
echo "🎨 Setting up display..."
clear
echo -en "\e[?25l"

# Initialize and start game
echo "🚀 Starting game loop..."
init_game
start_game_loop

# Clean up on exit
echo -en "\e[?25h"
echo "👋 Game ended!"
