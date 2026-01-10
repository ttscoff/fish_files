function __is_image -d 'Test if a file is an image'
    set -l stats (file "$argv" )

    if string match -q "*image data*" $stats
        return 0
    else
        return 1
    end
end
