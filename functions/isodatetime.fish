function isodatetime --description 'Return the current date and time in ISO 8601 format'
    set current_time (date +"%Y-%m-%dT%H:%M:%S%z")
    echo $current_time
end
