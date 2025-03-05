function pbgistp --description 'gist from clipboard'
    set -l content (pbpaste) # Get content from clipboard
    if test -z "$content"
        echo "Clipboard is empty, nothing to gist."
        return 1
    end
    gist -cP "$content" $argv
    # Notify the user that the gist was created successfully
    echo "Gist created from clipboard content."
end
