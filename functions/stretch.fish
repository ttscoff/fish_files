function stretch --description "Stretch and Clean URL (requires Stretch and Clean URL Shortcut)"
    set cleaned_url (echo "$argv" | shortcuts run "Stretch and Clean URL" -o - -i -)
    echo $cleaned_url | cat
end
