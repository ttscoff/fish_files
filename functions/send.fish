function send -d "Send to other iTerm pane"
    set target_dir (begin
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
        echo '                set end of pwdList to pwdOutput'
        echo '            end if'
        echo '        end tell'
        echo '    end repeat'
        echo '    return item 1 of pwdList'
        echo 'end tell'
    end | osascript -)

    # Now do whatever “send the $argv paths to that directory” means
    for p in $argv
        set target_dir (echo $target_dir | string trim)
        cp -r $p $target_dir/
        warn "Copied $p to $target_dir"
    end
end
