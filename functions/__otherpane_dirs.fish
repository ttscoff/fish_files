function __otherpane_dirs --description "List directories of all other iTerm panes in current tab"
    set -l raw (begin
        echo 'tell application "iTerm"'
        echo '    set theTab to current tab of current window'
        echo '    set sessionList to sessions of theTab'
        echo '    set pwdList to {}'
        echo '    set currSession to current session of theTab'
        echo '    repeat with aSession in sessionList'
        echo '        tell aSession'
        echo '            if id of aSession is not id of currSession then'
        echo '                write text "pwd"'
        echo '                delay 0.2 -- adjust if needed for slow shells'
        echo '                set sessionText to contents'
        echo '                set sessionLines to paragraphs of sessionText'
        echo '                set pwdOutput to ""'
        echo '                repeat with i from (count of sessionLines) to 2 by -1'
        echo '                    if (item i of sessionLines) is not "" and (item (i - 1) of sessionLines) contains "pwd" then'
        echo '                        set pwdOutput to item i of sessionLines'
        echo '                        exit repeat'
        echo '                    end if'
        echo '                end repeat'
        echo '                if pwdOutput is not "" then'
        echo '                    set end of pwdList to pwdOutput'
        echo '                end if'
        echo '            end if'
        echo '        end tell'
        echo '    end repeat'
        echo '    return pwdList as string'
        echo 'end tell'
    end | osascript -)
    # Split on comma and trim
    for d in (string split " " -- $raw)
        echo (string trim $d)
    end
end
