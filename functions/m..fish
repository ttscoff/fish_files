function m. --description 'Check if the current directory is bookmarked'
    marks --no-color | grep -e (pwd -P)\$ $argv
end
