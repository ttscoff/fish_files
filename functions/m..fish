# Defined in - @ line 1
function m. --description 'Check if the current directory is bookmarked'
	marks | grep -e (pwd -P)\$ $argv
end
