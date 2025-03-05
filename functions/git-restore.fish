function git-restore --description 'Restore files in the working tree from the index or another tree'
    if not string-empty $argv
        git restore $argv
    else
        git restore .
    end

    echo "Files have been restored successfully."
end
