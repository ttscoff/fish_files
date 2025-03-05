function history_select --description 'Select a command from history (fzf)'
    set selected_cmd (history | fzf)
    if test -n "$selected_cmd" # Check if a command was selected
        echo $selected_cmd
    else
        echo "No command selected."
    end
end
