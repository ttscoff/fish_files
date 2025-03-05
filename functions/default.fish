function default --argument val default -d 'Default value if first argument is empty'
    if not string-empty $val
        echo $val
    else
        echo $default
    end
end
