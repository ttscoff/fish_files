function capitalize --description 'Capitalize the first letter of a given text'
    read text
    if test -z "$text"
        echo "Error: No text provided."
        return 1
    end
    # Trim whitespace from the input text
    set text (echo $text | string trim)
    set first (echo $text | cut -c 1 | string upper)
    set rest (echo $text | cut -c 2-)
    echo $first$rest
end
