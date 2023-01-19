function lsgrep --description 'Wildcard folder/file search'
  # Convert search to regex: change .X to \.X, ? to ., and space or * to .*?
	set -l needle (echo $argv|sed -E 's/\.([a-z0-9]+)$/\\\.\1/'|sed -E 's/\?/./'| sed -E 's/[ *]/.*?/g')
	command ag --hidden --depth 3 -SUg "$needle" 2>/dev/null
end
