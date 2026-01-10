function ask -d 'Send a prompt to cursor-agent and print the response.'
    cursor-agent --output-format text -b --print agent "$argv"
end
