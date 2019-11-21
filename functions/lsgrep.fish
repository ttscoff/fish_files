function lsgrep -d "Wildcard folder/file search"
	set -l needle (echo $argv|sed -E 's/\.([a-z0-9]+)$/\\.\1/'|sed -E 's/\?/./'| sed -E 's/[ *]/.*?/g')
	command ag --depth 3 -S -g "$needle" 2>/dev/null
end
