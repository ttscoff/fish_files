function lb -d 'Select file in LaunchBar, fall back to the current directory'
	if test (count $argv) -eq 1
		if test -e (pwd)"/$argv[1]"
			open "x-launchbar:select?file="(pwd)"/$argv"
		else if test -e $argv[1]
			open "x-launchbar:select?file=$argv"
		else
			echo "File not found: $argv"
			return 127
		end
	else
		open "x-launchbar:select?file="(pwd)
	end
end
