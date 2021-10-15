function is --description 'test if given file is of a file type. is TYPE FILE'
	if test (mdls -name kMDItemContentTypeTree "$argv[2]" | sed '1d;$d' | grep -ci $argv[1]) -ne 0
		return 0
	else
		set -l stats (file "$argv[2]")

		if string match -q "*$argv[1]*" $stats
			return 0
		else
			return 1
		end
	end
end
