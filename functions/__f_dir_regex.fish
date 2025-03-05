function __f_dir_to_regex -d "Convert a directory to a regex"
    echo (printf '%s' (echo "$argv" | sed -E 's/ +//g' | sed -E 's/(.)/\1[^\/]*/g'))
end

function __f_dir_regex -d "Construct regex from multiple directory arguments"
    set -l section
    set -l regex (__f_dir_to_regex $argv[1])
    for arg in $argv[2..-1]
        set section (__f_dir_to_regex $arg)
        set regex "$regex/.*$section"
    end
    echo $regex
end
