function f -d "Open directory in Finder with jump shortcuts"
	if test (count $argv) -ne 1
		open -F "."
	else
		if test -d $argv[1]
			open -F $argv[1]
		else if test -d $MARKPATH/$argv[1] -a -L $MARKPATH/$argv[1]
			open -F (readlink $MARKPATH/$argv[1])
		else
			echo "No such mark: $argv[1]"
		end
	end
end
