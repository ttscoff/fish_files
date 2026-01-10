function flow -d 'Initialize git flow in the current repository.'
    if test (git origin &>/dev/null || false)
        git init
    end

    git flow init --preset=(fallback $argv github)
end
