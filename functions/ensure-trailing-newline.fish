function ensure-trailing-newline --argument file -d 'File to ensure trailing newline' --description 'Ensure a file ends with a newline'
    # Check if the file exists
    if not test -e $file
        echo "Error: File '$file' does not exist."
        return 1
    end

    # Check if the last character is a newline and add one if necessary
    if test -n (tail -c 1 $file)
        echo >>$file
    end
end
