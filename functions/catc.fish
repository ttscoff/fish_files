function catc -d "Concatenate files and print on the standard output (bypass cat alias)"
    if test (count $argv) -eq 0
        echo "Error: No files provided."
        return 1
    end
    # Optionally, add more functionality or error handling here in the future
    command cat $argv
end
