function __expand-otherpane_complete
    for dir in (__otherpane_dirs)
        echo $dir
    end
end

complete -c __expand-otherpane -a "(__expand-otherpane_complete)" -d "Other iTerm pane directories"
