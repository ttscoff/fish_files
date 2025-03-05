function copy -d "Copy piped contents to clipboard without newlines"
    cat | tr -d "\n" | pbcopy
end
