function retry --description 'Retry a command until it succeeds'
    set -l command $argv
    while true
        eval $command && break
        sleep 1
    end
end
