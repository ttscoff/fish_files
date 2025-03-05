function doing_now --description "Get the current doing now for tide"
    set -l result $DOING_NOW # (doing view tide)
    if test -n "$result"
        set -l parts (string split "||" "$result")
        set -l doingnow $parts[2]
        set -l startdate $parts[1]

        set -q tide_doing_now_max_length; or set -g tide_doing_now_max_length 40
        set doingnow (string sub --length $tide_doing_now_max_length $doingnow)"…"

        echo $doingnow
    end
end
