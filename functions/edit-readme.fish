function edit-readme -d 'Open the README file in the project root with $EDITOR.'
    set root (git root)
    for file in $root/README.md $root/README
        if file-exists $file
            $EDITOR $file
            return
        end
    end
    echo No README.md / README found
    return 1
end
