function funced-last --description 'Edit last function'
    # Check if the last-function-name command is available
    if not type -q last-function-name
        echo "Error: last-function-name function is not defined."
        return 1
    end

    set function_name (last-function-name)

    # Check if a function name was retrieved
    if test -z "$function_name"
        echo "Error: No last function name found."
        return 1
    end

    funced -s $function_name
end
