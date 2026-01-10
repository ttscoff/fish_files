# requires: is
function get-line -d 'Get a single line or line range from a text file'
    # Check if the user has provided the correct number of arguments
    # If the user has provided 3 arguments, set start, end, and file
    # If the user has provided 2 arguments, set start and file, and set end to start
    # If the user has provided 1 argument, set start to 1 and file to the first argument
    # If the user has provided no arguments, print usage message and return 1
    # If the user has provided more than 3 arguments, print usage message and return 1

    if test (count $argv) -eq 3
        set line_start $argv[1]
        set line_end $argv[2]
        set input $argv[3]
    else if test (count $argv) -eq 2
        set line_start $argv[1]
        set input $argv[2]
        set line_end $line_start
    else
        echo "Usage: get-line <line_start> [<end>] <file>"
        return 1
    end

    if not test -f $input
        echo "File not found: $input"
        return 1

    end
    if not is text $input
        echo "File is not a text file: $input"
        return 1
    end
    if not string match -q -r '^[0-9]+$' $line_start
        echo "line_start line must be a number: $line_start"
        return 1
    end
    if not string match -q -r '^[0-9]+$' $line_end
        echo "End line must be a number: $line_end"
        return 1
    end
    if test $line_start -gt $line_end
        echo "line_start line must be less than or equal to end line: $line_start > $line_end"
        return 1
    end
    if test $line_start -lt 1
        echo "line_start line must be greater than or equal to 1: $line_start"
        return 1
    end
    if test $line_end -lt 1
        echo "End line must be greater than or equal to 1: $line_end"
        return 1
    end
    if test $line_end -gt (count (cat $input))
        echo "End line must be less than or equal to the number of lines in the file: $line_end > $(count (cat $input))"
        return 1
    end

    bat --style numbers,grid -r $line_start:$line_end $input
    return 0
end
