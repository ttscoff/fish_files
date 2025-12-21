function map -d 'map a function over a list of items.'
    argparse h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: map COMMAND [ITEM...]"
        echo "   or: ... | map COMMAND"
        echo ""
        echo "Apply a command or function to each item in a list."
        echo ""
        echo "Arguments:"
        echo "  COMMAND            Command or function to execute for each item"
        echo "                     Can contain {} placeholder for inline substitution (like find -exec)"
        echo "  ITEM...            List of items to iterate over (optional if used in pipeline)"
        echo ""
        echo "Options:"
        echo "  -h, --help         Show this help message"
        echo ""
        echo "Examples:"
        echo "  map echo file1 file2 file3"
        echo "                     # Calls: echo file1, echo file2, echo file3"
        echo ""
        echo "  set arr file1 file2 file3; map echo \$arr"
        echo "                     # Fish arrays expand to separate arguments automatically"
        echo ""
        echo "  map \"echo {} | sed 's/foo/bar/'\" file1 file2"
        echo "                     # Replaces {} with each filename in the command"
        echo ""
        echo "  ls *.txt | map basename"
        echo "                     # Pipes each line to map, calls basename for each"
        echo ""
        echo "  set arr file1 file2 file3; echo \$arr | map echo"
        echo "                     # Piped arrays are split on whitespace automatically"
        echo ""
        echo "  printf '%s\\n' file1 file2 | map \"echo Processing: {}\""
        echo "                     # Each line from stdin is processed separately"
        echo ""
        echo "Notes:"
        echo "  - If COMMAND contains {}, it will be replaced with each item value"
        echo "  - If COMMAND doesn't contain {}, each item is passed as an argument"
        echo "  - When used in a pipeline, items are read from stdin and split on whitespace"
        echo "  - Fish arrays passed as arguments expand automatically (no pipe needed)"
        echo "  - {} works in both single and double quotes (no escaping needed)"
        return 0
    end

    if test (count $argv) -eq 0
        echo "Error: map requires at least one argument (COMMAND)" >&2
        echo "Use -h or --help for usage information." >&2
        return 1
    end

    set fnc $argv[1]
    set args $argv[2..-1]
    if test -z "$args"
        # Read from stdin - split on whitespace to handle arrays piped in
        while read -l line
            # Split line on spaces and process each item
            # This handles cases like: echo $arr | map COMMAND
            for item in (string split " " "$line")
                if test -n "$item"
                    # Check if command contains {} placeholder (like find -exec)
                    if string match -q '*{}*' "$fnc"
                        # Replace {} with the actual item value
                        set -l cmd (string replace -a '{}' "$item" "$fnc")
                        echo (eval $cmd)
                    else
                        # Use original behavior: pass item as argument
                        echo (eval $fnc (string escape $item))
                    end
                end
            end
        end
    else
        set -l result

        for item in $args
            # Check if command contains {} placeholder (like find -exec)
            if string match -q '*{}*' "$fnc"
                # Replace {} with the actual item value
                set -l cmd (string replace -a '{}' "$item" "$fnc")
                set -a result (eval $cmd)
            else
                # Use original behavior: pass item as argument
                set -a result (eval $fnc (string escape $item))
            end
        end

        echo -en (string join "\n" $result)
    end
end
