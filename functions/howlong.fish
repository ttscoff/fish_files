function howlong --wraps='echo $CMD_DURATION' --description 'show last command execution time'
    set duration $CMD_DURATION
    if test -n "$duration"
        echo "Last command duration: $duration $argv"
    else
        echo "No command duration available."
    end
end
