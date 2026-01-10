function install_cursor_commands -d 'Install Cursor command files from dotfiles to .cursor/commands, with optional filtering.'
    set filter ""
    if test (count $argv) -gt 0
        set filter $argv[1]
    end
    mkdir -p .cursor/commands
    set overwrite_all ''
    set regex ""
    if test -n "$filter"
        set -l chars (string split '' -- $filter)
        for c in $chars
            set regex "$regex$c.*?"
        end
    end
    for src in ~/dotfiles/cursor/commands/*
        set fname (basename $src)
        if test -n "$filter"
            if not string match -r -- "$regex" -- $fname >/dev/null
                continue
            end
        end
        set dest .cursor/commands/$fname
        if test -e $dest
            if test -z "$overwrite_all"
                read -l -P (set_color brmagenta)"File $dest already exists, what do you want to do?
"(set_color brwhite)"[(S)kip/(o)verwrite/(a)ll/(n)one] > " reply
                if not set -q reply; or test -z "$reply"
                    set reply s
                end
                switch $reply
                    case o
                        cp $src $dest
                        echo (set_color red)"Overwritten: $dest"(set_color normal)
                    case s
                        echo (set_color yellow)"Skipped: $dest"(set_color normal)
                        continue
                    case a
                        set overwrite_all o
                        cp $src $dest
                        echo (set_color red)"Overwritten (all): $dest"(set_color normal)
                    case n
                        set overwrite_all s
                        echo (set_color yellow)"Skipped (all): $dest"(set_color normal)
                        continue
                    case '*'
                        echo (set_color red)"Invalid input, skipping $dest"(set_color normal)
                        continue
                end
            else if test "$overwrite_all" = o
                cp $src $dest
            else if test "$overwrite_all" = s
                continue
            end
        else
            cp $src $dest
        end
    end
end
