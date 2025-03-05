function remove_user_path --description 'Shows user added PATH entries and removes the selected one (fzf)'
    set -l PATH_ENTRIES
    set to_remove (echo $fish_user_paths | tr " " "\n " | nl | awk '{print $1": "$2}'| fzf --reverse --prompt "Select path to remove")
    if test -z "$to_remove"
        echo "No path selected"
        return
    else
        set index (string match -r "^[0-9]+: " $to_remove | string replace ": " "")
        echo "Erasing $to_remove"
        echo "Press y to continue"
        set -l confirmation
        read confirmation -P (set_color -b green brwhite)"Are you sure?"(set_color normal)" "
        if test "$confirmation" = y
            set --erase --universal fish_user_paths[$index]
            echo "Path removed successfully."
        else
            echo "skipping..."
        end
    end
end
