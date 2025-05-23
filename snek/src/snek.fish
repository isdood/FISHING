#!/usr/bin/env fish

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
