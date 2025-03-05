function edit-gitconfig --description 'Edit the git config file for the current repo'
    # Check if the git directory exists
    if not test -d (git root)
        echo "Error: Not a git repository or the repository does not exist."
        return 1
    end

    $EDITOR (git root)/.git/config
end
