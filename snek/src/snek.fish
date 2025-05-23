#!/usr/bin/env fish

function cleanup_terminal
    # Restore terminal settings
    stty "$ORIGINAL_STTY"
    echo -en "\e[?25h" # Show cursor
    clear
end

function spawn_food
    set -g food_x (random 1 $GRID_WIDTH)
    set -g food_y (random 1 $GRID_HEIGHT)
end

function init_game
    echo -en "\e[H\e[2J" # Clear screen
    echo "🎮 Initializing game..."

    # Save original terminal settings and configure for game
    set -g ORIGINAL_STTY (stty -g)
    stty -icanon -echo min 1 time 0

    # Game dimensions
    set -g GRID_WIDTH 20
    set -g GRID_HEIGHT 10

    # Initial snake position
    set -g snake_x (math "floor($GRID_WIDTH/2)")
    set -g snake_y (math "floor($GRID_HEIGHT/2)")

    # Direction and segments
    set -g direction "right"
    set -g snake_segments
    for i in (seq 3)
        set -p snake_segments (math "$snake_x - $i + 1")","$snake_y
    end

    # Game state
    set -g game_running true
    set -g score 0

    spawn_food
end

# Source dependencies after function definitions
source (dirname (status filename))/engine/game_loop.fish
source (dirname (status filename))/ui/renderer.fish
source (dirname (status filename))/ui/input.fish

function on_exit --on-event fish_exit
    cleanup_terminal
end

# Initialize and run game
init_game
start_game_loop
cleanup_terminal
