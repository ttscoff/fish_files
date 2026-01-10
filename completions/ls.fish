function __otherpane_dirs_complete
    for dir in (__otherpane_dirs)
        echo $dir
    end
end

# When the current token is ~>, offer other pane directories as completions
# complete -c ls -a '(__otherpane_dirs_complete)' -d 'Other iTerm pane directories'
