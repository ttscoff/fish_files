function updown -d 'cd to a directory and then fuzzy search its tree'
	cd $argv[1]
	if test (count $argv) -gt 1
		cd (ffdir . $argv[2..-1])
	end
end
