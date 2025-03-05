function isodate --description 'Return the current date in ISO 8601 format'
    set current_date (date +%Y-%m-%d)
    echo $current_date
end
