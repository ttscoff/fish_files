function symlink --argument _from _to --description 'Create a symlink from _from to _to, makes paths absolute'
    if string-empty $_from; or string-empty $_to
        echo "symlink: must provide from and to arguments"
        return 1
    end

    set abs_to (realpath "$_to")

    if test -d $_to && not test -d $_from
        set to "$abs_to/"(basename $_from)
    else
        set to "$abs_to"
    end

    set from (realpath "$_from")

    if not test -e $from
        echo "symlink: `from` argument '$from' does not exist" >&2
        return 1
    end

    ln -s $from $to
end
