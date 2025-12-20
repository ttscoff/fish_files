function tween -d "Display lines between start and end line numbers"
    argparse e/exclusive b/bat h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: tween [-e|--exclusive] [-b|--bat] [-h|--help] FILE START END"
        echo "   or: tween [-e|--exclusive] [-b|--bat] [-h|--help] FILE START-END"
        echo ""
        echo "Options:"
        echo "  -e, --exclusive   Exclude the start and end lines from output"
        echo "  -b, --bat         Use bat instead of sed for syntax highlighting"
        echo "  -h, --help        Show this help message"
        echo ""
        echo "Arguments (can be in any order):"
        echo "  FILE              Path to the file to read"
        echo "  START             Starting line number (inclusive by default)"
        echo "  END               Ending line number (inclusive by default)"
        echo "  START-END         Range in format START-END (e.g., 5-10)"
        echo ""
        echo "Examples:"
        echo "  tween file.txt 10 20        # Display lines 10 through 20 (inclusive)"
        echo "  tween 10 20 file.txt        # Same as above, arguments in any order"
        echo "  tween file.txt 10-20        # Using dashed range"
        echo "  tween 10-20 file.txt        # Same as above, arguments in any order"
        echo "  tween -e file.txt 10 20     # Display lines 11 through 19 (exclusive)"
        echo "  tween -b file.txt 10 20     # Use bat for syntax highlighting"
        echo "  tween -b -e file.txt 10 20  # Use bat with exclusive mode"
        return 0
    end

    if test (count $argv) -lt 2 -o (count $argv) -gt 3
        echo "Error: tween requires 2 or 3 arguments: FILE START END or FILE START-END" >&2
        echo "Arguments can be in any order." >&2
        echo "Use -h or --help for usage information." >&2
        return 1
    end

    set -l file_path
    set -l start_line
    set -l end_line
    set -l numeric_args

    # Separate file path from numeric/range arguments
    for arg in $argv
        if string match -qr '^[0-9-]+$' "$arg"
            set -a numeric_args "$arg"
        else
            if test -n "$file_path"
                echo "Error: Multiple file paths detected: '$file_path' and '$arg'" >&2
                echo "Use -h or --help for usage information." >&2
                return 1
            end
            set file_path "$arg"
        end
    end

    # Validate we have exactly one file path
    if test -z "$file_path"
        echo "Error: No file path found. One argument must be a file path." >&2
        echo "Use -h or --help for usage information." >&2
        return 1
    end

    # Validate we have 1 or 2 numeric/range arguments
    if test (count $numeric_args) -eq 0
        echo "Error: No line numbers or range found. Need START END or START-END." >&2
        echo "Use -h or --help for usage information." >&2
        return 1
    else if test (count $numeric_args) -eq 1
        # Single argument: could be a range (e.g., "5-10") or a single number
        set -l arg $numeric_args[1]
        if string match -qr - "$arg"
            # It's a range
            if not string match -qr '^\d+-\d+$' "$arg"
                echo "Error: Invalid range format. Expected START-END (e.g., 5-10), got: $arg" >&2
                echo "Use -h or --help for usage information." >&2
                return 1
            end
            set -l range_parts (string split "-" "$arg")
            if test (count $range_parts) -ne 2
                echo "Error: Invalid range format. Expected START-END (e.g., 5-10), got: $arg" >&2
                echo "Use -h or --help for usage information." >&2
                return 1
            end
            set start_line $range_parts[1]
            set end_line $range_parts[2]
        else
            # Single number - treat as both start and end (display single line)
            set start_line $arg
            set end_line $arg
        end
    else if test (count $numeric_args) -eq 2
        # Two arguments: check if either is a range
        set -l arg1 $numeric_args[1]
        set -l arg2 $numeric_args[2]

        if string match -qr - "$arg1"
            # First is a range, ignore second
            if not string match -qr '^\d+-\d+$' "$arg1"
                echo "Error: Invalid range format. Expected START-END (e.g., 5-10), got: $arg1" >&2
                echo "Use -h or --help for usage information." >&2
                return 1
            end
            set -l range_parts (string split "-" "$arg1")
            set start_line $range_parts[1]
            set end_line $range_parts[2]
        else if string match -qr - "$arg2"
            # Second is a range, ignore first
            if not string match -qr '^\d+-\d+$' "$arg2"
                echo "Error: Invalid range format. Expected START-END (e.g., 5-10), got: $arg2" >&2
                echo "Use -h or --help for usage information." >&2
                return 1
            end
            set -l range_parts (string split "-" "$arg2")
            set start_line $range_parts[1]
            set end_line $range_parts[2]
        else
            # Both are single numbers - use as start and end
            set start_line $arg1
            set end_line $arg2
        end
    else
        echo "Error: Too many numeric arguments. Expected 1 or 2, got: "(count $numeric_args) >&2
        echo "Use -h or --help for usage information." >&2
        return 1
    end

    if not test -f "$file_path"
        echo "Error: File '$file_path' does not exist or is not a regular file." >&2
        return 1
    end

    # Validate that start and end are numbers
    if not string match -qr '^\d+$' "$start_line"
        echo "Error: START must be a positive integer, got: $start_line" >&2
        return 1
    end

    if not string match -qr '^\d+$' "$end_line"
        echo "Error: END must be a positive integer, got: $end_line" >&2
        return 1
    end

    # Validate that start <= end
    if test $start_line -gt $end_line
        echo "Error: START ($start_line) must be less than or equal to END ($end_line)" >&2
        return 1
    end

    # Handle exclusive mode
    if set -q _flag_exclusive
        set -l exclusive_start (math $start_line + 1)
        set -l exclusive_end (math $end_line - 1)

        # Check if there are any lines to display in exclusive mode
        if test $exclusive_start -gt $exclusive_end
            # No lines to display (e.g., start=10, end=11 in exclusive mode)
            return 0
        end

        if set -q _flag_bat
            bat --line-range "$exclusive_start:$exclusive_end" "$file_path"
        else
            sed -n "$exclusive_start,$exclusive_end p" "$file_path"
        end
    else
        # Inclusive mode (default)
        if set -q _flag_bat
            bat --line-range "$start_line:$end_line" "$file_path"
        else
            sed -n "$start_line,$end_line p" "$file_path"
        end
    end
end
