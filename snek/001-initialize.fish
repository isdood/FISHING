#!/usr/bin/env fish

# 🌟 Snek Game Initialization Script
# Created by: isdood
# Date: 2025-05-22

function print_glimmer
    set_color -o brmagenta
    echo "✨ $argv"
    set_color normal
end

function create_directory
    if not test -d $argv[1]
        mkdir -p $argv[1]
        print_glimmer "Created directory: $argv[1]"
    else
        print_glimmer "Directory already exists: $argv[1]"
    end
end

function create_file
    if not test -f $argv[1]
        touch $argv[1]
        print_glimmer "Created file: $argv[1]"
    else
        print_glimmer "File already exists: $argv[1]"
    end
end

# 🎨 Welcome message with sparkles
print_glimmer "🌟 Initializing Snek Game Project Structure 🌟"

# 🔮 Create main project directories
set base_dir (dirname (status filename))
cd $base_dir

# 📁 Create directory structure
create_directory "src"           # Core source files
create_directory "src/engine"    # Game engine components
create_directory "src/ui"        # User interface components
create_directory "src/utils"     # Utility functions
create_directory "config"        # Configuration files
create_directory "assets"        # Game assets (ASCII art, etc.)
create_directory "tests"         # Test files
create_directory "docs"          # Additional documentation

# 📝 Create initial files
create_file "src/snek.fish"              # Main game file
create_file "src/engine/game_loop.fish"  # Game loop logic
create_file "src/engine/collision.fish"  # Collision detection
create_file "src/ui/renderer.fish"       # Screen rendering
create_file "src/ui/input.fish"          # Input handling
create_file "src/utils/logger.fish"      # Logging utilities
create_file "config/settings.fish"       # Game settings
create_file "assets/sprites.txt"         # ASCII art sprites
create_file "tests/test_collision.fish"  # Test files
create_file ".gitignore"                 # Git ignore file

# 🌟 Make main game file executable
chmod +x src/snek.fish

# ✨ Create basic .gitignore content
echo "*.log" > .gitignore
echo "*.tmp" >> .gitignore
echo ".DS_Store" >> .gitignore

print_glimmer "🎉 Initialization complete! Your snek project structure is ready!"
print_glimmer "
Directory structure created:
├── src/
│   ├── engine/
│   ├── ui/
│   └── utils/
├── config/
├── assets/
├── tests/
└── docs/
"

print_glimmer "Next steps:"
print_glimmer "1. Navigate to src/snek.fish to start implementing the main game"
print_glimmer "2. Add game logic in src/engine/"
print_glimmer "3. Customize UI components in src/ui/"
print_glimmer "4. Have fun creating your snek! 🐍"
