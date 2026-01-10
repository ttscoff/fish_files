function ca -d 'Send a prompt to cursor-agent, print the response, and play a sound.'
    cursor-agent --output-format text --print "$argv"
    afplay /System/Library/Sounds/Hero.aiff
end
