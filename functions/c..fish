function c. --description 'Run Cursor in a directory'
    set query $argv[1]

    # If no argument, use current directory
    if test -z "$query"
        set wsfiles *.code-workspace
        if test -e "$wsfiles[1]"
            cursor $wsfiles[1]
        else
            cursor .
        end
        return
    end

    # If argument is an existing directory, use it
    if test -d "$query"
        cursor "$query"
        return
    end

    # Try to match command
    set -l files ./.cursor/commands/*.md
    set -l match ""
    set -l matchlen 99999

    for file in $files
        set fname (basename $file .md)
        if string match -q "*$query*" $fname
            set len (string length $fname)
            if test $len -lt $matchlen
                set match $fname
                set matchlen $len
            end
        end
    end

    if test -n "$match"
        echo (set_color green)"Match found: "(set_color brwhite)$match(set_color normal)
        agent --approve-mcps --trust --output-format text --print "Read .cursor/commands/$match.md and follow its instructions."
        return 0
    else
        warn -e "Directory or command not found"
        return 1
    end
end
