function confirm -d "Prompt for confirmation"
    read -P "$argv> " response
    contains $response y Y yes YES
end
