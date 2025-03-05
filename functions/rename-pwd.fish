function rename-pwd --argument new_name --description 'Rename the current directory to new_name'
    set current (basename $PWD)

    # Check if the new_name already exists
    if test -e $new_name
        echo "Error: Directory '$new_name' already exists."
        return 1
    end

    cd ..
    mv -n $current $new_name
    # Check if the move was successful
    if test $status -eq 0
        cd $new_name
    else
        echo "Error: Failed to rename the directory."
        return 1
    end
end
