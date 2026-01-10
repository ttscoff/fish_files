function cac --description 'Run a cursor-agent command from a command file'
    cursor-agent --output-format text --print .cursor/commands/$argv[1].md
    afplay /System/Library/Sounds/Hero.aiff
end
