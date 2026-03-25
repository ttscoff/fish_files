function flow -d 'Initialize git flow in the current repository.'
    if not test -f .git
        git init
    end

    git flow init --preset=(fallback $argv github)
end
