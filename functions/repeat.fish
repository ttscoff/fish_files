function repeat --description 'Repeat the given command indefinitely with a pause'
    set -l command $argv
    while true
        eval $command
        sleep 1
    end
end
