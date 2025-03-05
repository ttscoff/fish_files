function idletil --description 'Wait until system idle time has reached X seconds and optionally execute command (requires beengone)'
    argparse h/help 'c/command=+' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: idletil SECONDS [-c \"command to execute\"]"
        echo "SECONDS may be represented as XdXhXmXs or any combination"
        return 0
    end

    set -l minimum "$argv"

    if test (string match -r "\d+[dhms]" $minimum)
        set minimum (echo $minimum | sed 's/d/*24*3600 +/g; s/h/*3600 +/g; s/m/*60 +/g; s/s/\+/g; s/+[ ]*$//g' | bc)
    end

    warn "Waiting $minimum seconds of idle time"

    while true
        if beengone -m $minimum
            if set -q _flag_c
                echo "Time's up: "(beengone -n)" seconds"
                for cmd in $_flag_c
                    eval $cmd
                    if test $status != 0
                        return $status
                    end
                end
                return 0
            end

            return 0
        end

        printf "%b" "\r\e[2K"(beengone -n)
        sleep 1
    end

    return 1
end
