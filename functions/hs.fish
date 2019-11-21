function hs --description 'Search, select, and exec from history'
	eval (history $argv|fzf)
end
