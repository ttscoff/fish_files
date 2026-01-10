function trim-left --description 'Trim character left' --argument str
    # Ensure the input is not empty
    if test -z "$str"
        echo "Error: No string provided."
        return 1
    end
    # Perform the trim operation
    sed "s|^$str||"
end
