function hist --description 'Print the command from history'
    set cmd $(commandline -o)
    set num $(string replace -r '!(\d+)' '$1' $cmd[-1])
    if test -n "$num" # Check if num is not empty
        echo $history[$num]
    else
        echo "No history entry found."
    end
end
