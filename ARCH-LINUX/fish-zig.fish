function fish-zig --description 'Execute zig build with version info'
    # Display a separator line
    echo "╭───────────────────────────────────╮"
    echo "│         Zig Build Helper          │"
    echo "╰───────────────────────────────────╯"

    # Show Zig version
    echo "📦 Zig Version:"
    if command -v zig >/dev/null
        zig version
    else
        echo "Error: Zig is not installed or not in PATH"
        return 1
    end

    echo # Empty line for better readability
    echo "🔨 Starting build..."
    echo "───────────────────────────────────"

    # Execute zig build in the current directory
    if test -f build.zig
        zig build
    else
        echo "Error: No build.zig file found in current directory"
        return 1
    end
end
