functions -q __original_cd;
    or functions -c cd __original_cd
functions -e cd
    and functions -c cd_fuzz cd

functions -q __bt_fish_complete_path;
    or functions -c __fish_complete_path __bt_fish_complete_path

function __fish_complete_path --description 'Complete using path'
    set -l target
    set -l description
    switch (count $argv)
        case 0
            # pass
        case 1
            set target "$argv[1]"
        case 2 "*"
            set target "$argv[1]"
            set description "$argv[2]"
    end
    set -l targets "$target"*
    if set -q targets[1]
        printf "%s\t$description\n" (command ls -dp $targets)
    else
        __complete_fasd_path (string join "/" $argv)
    end
end

function __complete_fasd_path
    set -l res

    set -l token (string split " " (string trim (string replace "/" " " $argv)))
    set -l dir_only false

    # If the current token is empty or ends with / or the command is cd, search directories only
    if test (string match -r '/$' $argv[-1])
        set dir_only true
    end

    if test -n "$token"
        # search current subdirectories for match
        if $dir_only
            set res (string trim (ffdir -d1 --multi . $token))
        else
            set res (string trim (fffile -d1 --multi . $token))
        end
        # if no match is found from the current directory
        if test (string match '.' $res)
            set res
        end
    end

    if $dir_only
        set -a res (fasd -tldR0 $token| head -n 5 | awk '{print $0}')
    else
        set -a res (fasd -tlR0 $token| head -n 5 | awk '{print $0}')
    end

    printf "%s\t$description\n" (command ls -dp $res)
end
