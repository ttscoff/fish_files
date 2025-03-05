function edit-git --description 'Edit the first file changed in the current git branch'
    $EDITOR (git-changing-files | head -1)
end
