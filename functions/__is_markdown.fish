function __is_markdown -d "Test if a file is a markdown file"
    set -l exts md mmd markdown mdwn mkd mkdn mkdown mdown
    set -l ext (get_ext $argv[-1])
    if not is text $argv[-1]
        return 1
    end
    if test -z $ext
        return 1
    end
    # Check if the file extension is in the list of markdown extensions
    if contains $ext $exts
        return 0
    else
        return 1
    end
end
