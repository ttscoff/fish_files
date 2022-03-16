function halp -d 'Get help for any builtin, alias, or function'
    set -l apro false
    set -l helpstring "Usage: halp COMMAND";
    set -l options "k/apropos" "h/help"

    argparse $options -- $argv

    if set -q _flag_help
        or test (count $argv) -ne 1
        echo $helpstring
        return 0
    end

    if set -q _flag_apropos
        set apro true
    end

    set -l helpresult
    set -l cmd $argv[1]

    if not type -q $cmd
        if $apro
            man -k $cmd
        else
            warn -e "Not a command"
            return 1
        end
    end

    set -l cmdtest (type -t $cmd)

    if test (string match "file" $cmdtest)
        if test (man $cmd &> /dev/null; echo $status) -eq 0
            man $cmd
        else if test ($cmd -h &> /dev/null; echo $status) -eq 0
            $cmd -h
        else
            warn -i "$cmd is a binary with no help flag or man page"
            type $cmd
        end
    else
        if test (alias | grep -c -E "^alias $cmd ") -gt 0
            warn -i "$cmd is an alias:  "
            alias | grep -E "^alias $cmd " | sed -E "s/alias $cmd //"
        else
            if test (string match "function" $cmdtest)
                set -l d (functions -Dv $cmd)
                warn -i "$cmd is a function: "(set_color --bold white)"$d[5]"(set_color normal)
                warn -i (set_color cyan)"$d[1]:$d[3] ($d[2])"(set_color normal)
                read -n 1 -p "set_color green; echo -n 'Display function? (y/N)'; set_color normal; echo '> '" result
                if test (string match "y" $result)
                    functions $cmd
                end
            else if test (string match "builtin" $cmdtest)
                warn -i "$cmd is a builtin:"
                # if you don't have Dash with the fish docset loaded, switch the lines below
                # help $cmd
                open "dash://fish%3A$cmd"
            end
        end
    end
end
