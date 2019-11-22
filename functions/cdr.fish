function cdr --description 'cd to a recently visited directory'
	cd (fasd -tldR $argv|fzf --height=8 --prompt="cd> " --layout=default)
end
