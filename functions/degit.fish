function degit -d 'Remove all traces of git from a folder'
	find . -name '.git' -exec rm -rf {} \;
end
