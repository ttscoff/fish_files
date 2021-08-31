function mdgrep --wraps='rg -S --type markdown' --description 'alias mdgrep=rg -S --type markdown'
  rg -S --type markdown $argv; 
end
