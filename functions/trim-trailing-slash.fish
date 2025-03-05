function trim-trailing-slash --description 'Trim trailing slashes from a string'
    # Ensure the input is not empty
    if test -z "$argv"
        command cat | string replace -r '/$' ''
        return 0
    end
    # Perform the trim operation
    set str (string replace -r '/$' '' -- $argv) # Update str with trimmed value
    echo $str # Output the trimmed string
    return 0 # Indicate successful execution
end
