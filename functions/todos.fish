function todos --wraps=ack -d 'Search for TODOs and FIXMEs in the current directory'
    # A placeholder for additional features or options
    # You can implement functionality here if needed

    # Check if arguments were provided
    if test (count $argv) -eq 0
        echo "Error: No search term provided."
        return 1
    end

    ack --nobreak --nocolor "(TODO|FIXME):" | sed -E "s/(.*:[[:digit:]]+):.*((TODO|FIXME):.*)/\2 :>> \1/" | grep -E --color=always ":>>.*:\d+" $argv
end
