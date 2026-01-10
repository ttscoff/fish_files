

function c. --description 'Run Cursor in a directory'
    set query $argv[1]
    # Skip matching if no argument or if argument is a directory
    if test -z "$query"; or test -d "$query"
        cursor (fallback $argv .)
        return
    end

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
        agent --approve-mcps --output-format text --print .cursor/commands/$match.md
    else
        cursor (fallback $argv .)
    end
end
