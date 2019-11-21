function fallback -d 'allow a fallback value for variable'
	if test (count $argv) = 1
		echo $argv
	else
		echo $argv[1..-2]
	end
end
