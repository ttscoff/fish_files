function gitrelease -d 'Create a git release'
	hub release create -m "v$argv" $argv
end
