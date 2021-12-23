function mdgrep --wraps='rg' --description 'alias mdgrep=rg -S --type markdown'
	rg -S --type markdown $argv; 
end
