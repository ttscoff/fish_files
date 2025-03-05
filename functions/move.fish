function move --description 'move files and directories'
    # fish 3.0.0 introduced a bug that causes `mv` to fail if the first argument is a symlink with a trailing slash.
    set from $argv[1]
    if is-symlink $from; and string match --quiet --regex --entire '/$' $from
        echo move: `from` argument '"'$from'"' is a symlink with a trailing slash.
        echo move: to rename a symlink, remove the trailing slash from the argument.
        return 1
    end
    mv -i $argv
    # Notify the user that the move was successful
    echo "Moved '$from' to '$argv[2]'"
end
