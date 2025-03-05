function mdgrep --wraps='rg' --description 'ripgrep for markdown'
    rg -S --type markdown $argv
end
