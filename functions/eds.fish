function eds -d 'Shortcut for editscript'
	# set -l result (which $argv)
	# if test -n "$result" && istext "$result" 2> /dev/null
	# 	$EDITOR "$result"
	# else
		editscript $argv
	# end
end
