function trim-scheme --description 'Trim the scheme from a URL'
    # Ensure the input is not empty
    if test -z "$argv"
        echo "Error: No input provided."
        return 1
    end
    # Perform the trim operation
    sed -r 's|.+://||' "$argv"
end
