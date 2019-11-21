function cdt -d 'Change dir based on TagFiler tags'
	# assumes cdt.bash (in the bash_scripts folder) is in your path
	set -l target (bash cdt.bash $argv)
	if test (string length $target) -gt 0
		cd "$target"
		return 0
	else
		echo "No target directory found"
		return 1
	end
end
