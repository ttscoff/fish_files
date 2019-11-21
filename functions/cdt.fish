function cdt -d 'Change dir based on TagFiler tags'
	set -l target (bash ~/scripts/fish/cdt.bash $argv)
	if test (string length $target) -gt 0
		cd "$target"
		return 0
	else
		echo "No target directory found"
		return 1
	end
end
