

function tween -d "Display lines between start and end line numbers or string matches"
    argparse e/exclusive b/bat h/help r/regex -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: tween [-e|--exclusive] [-b|--bat] [-r|--regex] [-h|--help] FILE RANGE[,RANGE...]"
        echo "   or: tween [-e|--exclusive] [-b|--bat] [-r|--regex] [-h|--help] FILE START END[,RANGE...]"
        echo "   or: tween [-e|--exclusive] [-b|--bat] [-r|--regex] [-h|--help] FILE START-END[,RANGE...]"
        echo ""
        echo "Options:"
        echo "  -e, --exclusive   Exclude the start and end lines from output"
        echo "  -b, --bat         Use bat instead of sed for syntax highlighting"
        echo "  -r, --regex       Treat all string arguments as regular expressions"
        echo "  -h, --help        Show this help message"
        echo ""
        echo "Arguments (can be in any order):"
        echo "  FILE              Path to the file to read"
        echo "  START, END        Line numbers (can use +N or -N for offsets)"
        echo "  STRING            Quoted string to match line (inclusive)"
        echo "  /REGEX/           Regex pattern to match line (inclusive)"
        echo "  Multiple ranges   Separate multiple ranges with commas (e.g., 5-10,15-20 or 5 10, 15 20, 'START' +20)"
        echo ""
        echo "Examples:"
        echo "  tween file.txt 10 20                # Display lines 10 through 20 (inclusive)"
        echo "  tween 10 20 file.txt                # Same as above, arguments in any order"
        echo "  tween file.txt 10-20                # Using dashed range"
        echo "  tween 10-20 file.txt                # Same as above, arguments in any order"
        echo "  tween file.txt 10-20,30-40          # Multiple ranges, dashed format"
        echo "  tween file.txt 10 20, 30 40         # Multiple ranges, space format"
        echo "  tween file.txt 10 +20               # Lines 10 through 30"
        echo "  tween file.txt 50 -10               # Lines 50 to 10 from end"
        echo "  tween file.txt 'START' +20          # Line matching 'START' plus 20 lines"
        echo "  tween file.txt 50-'END'             # Lines 50 to line matching 'END'"
        echo "  tween file.txt /START/ +20          # Regex match for 'START' plus 20 lines"
        echo "  tween -r file.txt 'foo' 'bar'       # Both patterns as regex"
        echo "  cat file.txt | tween 10-20,30-40 -  # Pipe input, multiple ranges"
        return 0
    end


    set -l file_path
    set -l arglist
    # Separate file path from other arguments
    for arg in $argv
        if test "$arg" = -
            if test -n "$file_path"
                echo "Error: Multiple file paths detected: '$file_path' and '-'" >&2
                echo "Use -h or --help for usage information." >&2
                return 1
            end
            set file_path -
        else if test -f "$arg"
            if test -n "$file_path"
                echo "Error: Multiple file paths detected: '$file_path' and '$arg'" >&2
                echo "Use -h or --help for usage information." >&2
                return 1
            end
            set file_path "$arg"
        else
            set -a arglist "$arg"
        end
    end

    # Join all non-file args into a single string, then split by comma for ranges
    set -l range_args
    if test (count $arglist) -gt 0
        set range_args (string join " " $arglist | string split ",")
    end


    set -l use_temp_file 0
    set -l temp_file

    # If no file_path, check for piped input (stdin is not a terminal)
    set -l use_temp_file 0
    set -l temp_file
    if test -z "$file_path" -o "$file_path" = -
        if test ! -t 0
            set temp_file (mktemp /tmp/tween.XXXXXX)
            cat >$temp_file
            set file_path $temp_file
            set use_temp_file 1
        else
            echo "Error: No file path found and no piped input detected." >&2
            echo "Use -h or --help for usage information." >&2
            return 1
        end
    end

    # Validate we have at least one range argument
    if test (count $range_args) -eq 0
        echo "Error: No line numbers or range found. Need START END or START-END." >&2
        echo "Use -h or --help for usage information." >&2
        return 1
    end

    if not test -f "$file_path"
        echo "Error: File '$file_path' does not exist or is not a regular file." >&2
        if test "$use_temp_file" -eq 1
            rm -f $file_path
        end
        return 1
    end

    # Helper: get line number for a string or regex pattern
    function __tween_find_line --argument-names pattern file regex_mode
        if test "$regex_mode" -eq 1
            set -l pat (string replace -r '^/(.*)/$' '$1' -- "$pattern")
            grep -n -m 1 -E "$pat" "$file" | cut -d: -f1
        else
            grep -n -m 1 -F "$pattern" "$file" | cut -d: -f1
        end
    end

    # Helper: get last line number for a string or regex pattern
    function __tween_find_last_line --argument-names pattern file regex_mode
        if test "$regex_mode" -eq 1
            set -l pat (string replace -r '^/(.*)/$' '$1' -- "$pattern")
            grep -n -E "$pat" "$file" | tail -n 1 | cut -d: -f1
        else
            grep -n -F "$pattern" "$file" | tail -n 1 | cut -d: -f1
        end
    end

    set -l total_lines (wc -l < "$file_path" | string trim)

    for range in $range_args
        set -l start_line
        set -l end_line
        set -l parts (string split " " (string trim -- "$range"))
        set -l regex_mode 0
        if set -q _flag_regex
            set regex_mode 1
        end

        # Parse start
        set -l s $parts[1]
        set -l e
        if test (count $parts) -ge 2
            set e $parts[2]
        else if string match -qr - $s
            set -l dash_parts (string split "-" $s)
            set s $dash_parts[1]
            set e $dash_parts[2]
        end

        # Start line
        if string match -qr '^\d+$' -- $s
            set start_line $s
        else if string match -qr '^\+\d+$' -- $s
            set start_line (math 1 + $s)
        else if string match -qr '^/.*?/$' -- $s
            set start_line (__tween_find_line $s $file_path 1)
            set regex_mode 1
        else
            set start_line (__tween_find_line $s $file_path $regex_mode)
        end

        # End line
        if test -z "$e"
            set end_line $start_line
        else if string match -qr '^\+\d+$' -- $e
            set end_line (math $start_line + (string sub --start 2 $e))
        else if string match -qr '^-\d+$' -- $e
            set end_line (math $total_lines - (string sub --start 2 $e) + 1)
        else if string match -qr '^\d+$' -- $e
            set end_line $e
        else if string match -qr '^/.*?/$' -- $e
            set end_line (__tween_find_last_line $e $file_path 1)
            set regex_mode 1
        else
            set end_line (__tween_find_last_line $e $file_path $regex_mode)
        end

        # If both start and end are string/regex, ensure we output the full range between them
        if not string match -qr '^\d+$' -- $s; and not string match -qr '^\d+$' -- $e; and not string match -qr '^\+\d+$' -- $e; and not string match -qr '^-\d+$' -- $e
            # Both are string/regex, so output the full range between their matches
            # (already handled by start_line and end_line logic above)
            # But if either is not found, skip
            if test -z "$start_line" -o -z "$end_line"
            end
        end

        if test -z "$start_line" -o -z "$end_line"
            echo "Error: Could not resolve line numbers for range: $range" >&2
            continue
        end
        if not string match -qr '^\d+$' "$start_line"
            echo "Error: START must resolve to a positive integer, got: $start_line" >&2
            continue
        end
        if not string match -qr '^\d+$' "$end_line"
            echo "Error: END must resolve to a positive integer, got: $end_line" >&2
            continue
        end
        if test $start_line -gt $end_line
            echo "Error: START ($start_line) must be less than or equal to END ($end_line)" >&2
            continue
        end

        # Handle exclusive mode
        if set -q _flag_exclusive
            set -l exclusive_start (math $start_line + 1)
            set -l exclusive_end (math $end_line - 1)
            if test $exclusive_start -gt $exclusive_end
                continue
            end
            if set -q _flag_bat
                bat --line-range "$exclusive_start:$exclusive_end" "$file_path"
            else
                sed -n "$exclusive_start,$exclusive_end p" "$file_path"
            end
        else
            if set -q _flag_bat
                bat --line-range "$start_line:$end_line" "$file_path"
            else
                sed -n "$start_line,$end_line p" "$file_path"
            end
        end
    end
    # Clean up temp file if used
    if test "$use_temp_file" -eq 1
        rm -f $file_path
    end
end
