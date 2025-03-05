function trim-right --argument char -d 'Trim character right'
    # Ensure the input is not empty
    if test -z "$char"
        echo "Error: No character provided."
        return 1
    end
    # Perform the trim operation
    sed "s|$char\$||"
end
