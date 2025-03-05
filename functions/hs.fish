function hs --description 'Search, select, and exec from history'
	commandline -r "$(history $argv|fzf -1 -0)"
end
