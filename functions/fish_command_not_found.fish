function fish_command_not_found
    set cmd $argv[1]
    set args $argv[2..-1]

    # If argument is an existing directory, use it
    if test -d "$cmd"
        cd "$cmd"
        return $status
    end

    # Only bother if we're in a directory that looks like a project
    # (optional: you can loosen/tighten this)
    if test -f buildnotes.md
        set test_cmd (string replace -r '^\./?' '' $cmd)
        if howzit --test-search $test_cmd >/dev/null 2>&1
            echo (set_color green)"Howzit match found: "(set_color brwhite)$test_cmd(set_color normal)
            howzit -r $test_cmd -- $args
            return $status
        end
    end

    # Try to match command
    set -l files ./.cursor/commands/*.md
    set -l match ""
    set -l matchlen 99999

    for file in $files
        set test_cmd (string replace -r '^\./?' '' $cmd)
        set fname (basename $file .md)
        if string match -q "*$test_cmd*" $fname
            set len (string length $fname)
            if test $len -lt $matchlen
                set match $fname
                set matchlen $len
            end
        end
    end

    if test -n "$match"
        echo (set_color green)"Cursor match found: "(set_color brwhite)$match(set_color normal)
        agent --approve-mcps --trust --output-format text --print "Read .cursor/commands/$match.md and follow its instructions."
        return 0
    end

    echo "fish: Unknown command '$cmd'"
    return 127
end
