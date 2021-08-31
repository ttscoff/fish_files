function geminstall --description 'install a gem with fuzzy search'
	gem install (gem search "$argv" | awk '{ print $1; }' | fzf)
end
