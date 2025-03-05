function title-case --description 'Convert a string to title case'
    # Check if the input is empty
    if test -z "$argv"
        echo "Error: No text provided."
        return 1
    end
    # Read the input text
    read text
    set words (string split " " -- $text)
    if test (count $words) -eq 0
        echo "Error: No words to convert."
        return 1
    end
    set output (echo $words[1] | capitalize)
    for word in $words[2..-1]
        set output "$output "(echo $word | capitalize)
    end
    echo $output
end
