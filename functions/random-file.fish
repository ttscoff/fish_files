function random-file --description 'Select a random file from the current directory'
    set random_file (find . -type f | shuf -n1)
    if test -n "$random_file"
        echo $random_file
    else
        echo "No files found."
    end
end
