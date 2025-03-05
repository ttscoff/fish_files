function git-restage --description 'Restage all changes in the current git repository'
    # Add a check to see if there are changes to restage
    if test -z "(git diff --cached --name-only)"
        echo "No changes to restage."
        return 1
    end

    # Proceed to restage changes
    git add (git diff --name-only --cached)

    echo "Changes have been restaged successfully."
end
