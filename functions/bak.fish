function bak -d "move file to .bak version"
	set -l filename $argv[1]
	# local filetime=(date +%Y%m%d_%H%M%S)
	mv $filename $filename".bak"
end
