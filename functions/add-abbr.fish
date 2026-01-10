function add-abbr --description 'add abbr to custom abbr file'
    abbr --add $argv[1] "$argv[2..]"
    echo "abbr --add $argv[1] '$argv[2..]'" >>~/.config/fish/custom/abbr.fish
end
