function unbak -d "remove bak extension"
	set -l filename $argv[1]
	set -l unbakd (string replace -r '\.bak$' "" $filename)
	mv $filename $unbakd
end
