function __expand-otherpane --description "Insert the other iTerm pane's directory at cursor, or offer completions if multiple"
    set -l dirs (__otherpane_dirs)
    if test (count $dirs) -eq 1
        commandline -i $dirs[1]
    end
    # If more than one, do nothing: rely on completion
end
