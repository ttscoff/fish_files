function clean-unzip --argument zipfile -d 'Unzip a zipfile to a clean folder' --description 'Unzip a zipfile to a clean folder'
    if not test (echo $zipfile | string sub --start=-4) = .zip
        echo (status function): argument must be a zipfile
        return 1
    end

    # Check if the zipfile is clean before unzipping
    if is-clean-zip $zipfile
        unzip $zipfile
    else
        set folder_name (echo $zipfile | trim-right '.zip')
        set target (basename $folder_name)
        mkdir $target || return 1
        unzip $zipfile -d $target
    end

    echo "Successfully unzipped $zipfile"
end
