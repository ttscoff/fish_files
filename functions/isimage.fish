function isimage --description 'test if given file is plain text'

    if is image "$argv"
        echo yep >&2
        return 0
    else
        echo nope >&2
        return 1
    end
end
