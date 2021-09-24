function is -d 'test if given file is of a file type. is TYPE FILE'
	if test (mdls -name kMDItemContentTypeTree "$argv[2]" | sed '1d;$d' | grep -ci $argv[1]) -ne 0
		echo "yep" >&2
		return 0
	else
		echo "nope" >&2
		return 1
	end
end
