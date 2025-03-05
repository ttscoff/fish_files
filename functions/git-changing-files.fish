function git-changing-files --description 'List all files that have changed in the current git repository'
    git diff --name-only
    git ls-files --others --exclude-standard
end
