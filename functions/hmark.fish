function hook -d 'Open file in Hookmark.app'
    if test (count $argv) -eq 0
        echo "No arguments provided. Please provide a file to open."
        return 1
    end

    open -a Hookmark $argv
end
