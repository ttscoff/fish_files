function whatsonport --description 'find out what PID is running on a port (requires password)'
    set -l pass (security find-generic-password -l "root password" -a root -w|tr -d '\n')
    echo $pass | sudo -S lsof -nP -iTCP:$argv -sTCP:LISTEN
end
