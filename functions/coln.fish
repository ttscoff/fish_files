function coln -d 'Column N'
    if test (count $argv) -ne 1
        echo "Error: Please specify the column number."
        return 1
    end

    # Validate that the column number is a positive integer
    if test $argv[1] -lt 1
        echo "Error: Column number must be a positive integer."
        return 1
    end

    awk '{print $'$argv[1]'}'
end
