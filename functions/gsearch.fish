function gsearch -d 'Grep git commit history'

    if test -z "$argv"
        echo "Please provide a search term."
        return 1
    end

    git log -g --grep="$argv"

    echo "Search completed for term: $argv."
end
