function cdd -d 'Choose cd dir from menu (fzf)'
	# set -l needle (echo "$argv" | sed -E 's/ +/.*/g')
	set -l needle (__regex_from_args -f $argv)
	set -l target (find . -type d -maxdepth 3 | grep -Ei $needle'[^/]*$' | fzf -s 20 -1 -0 -q "$argv")
	if test "$target" = ""
		echo "No match"
		return 1
	else
		cd "$target"
	end
end
