if functions -q expand-word
	expand-word -p '^s/..*/.*$' -e 'echo -n "$history[1]" | sed -e (commandline -t)/g'
	# expand-word -p '^//.*/$' -e '__expand_path'
	# expand-word -p '^//.*[^/]$' -e '__expand_path'

	# function __expand_path
	# 	set -l token (string trim (commandline -t | tr "/" " "))
	# 	set -l process (commandline -p)
	# 	set -l res

	# 	if test (string match -r '/$' $token) || test (string match -r '^\s*cd ' $process)
	# 		set res (fasd -tldR0 $token| head -n 5 | awk '{print $0"/"}')
	# 	else
	# 		set res (fasd -tlR0 $token| head -n 5 | awk '{print $0}')
	# 	end

	# 	if test -z "$res"
	# 		set res (fffile ~ $token)
	# 		if test (string match -r '^\.$' $res)
	# 			commandline -t
	# 		else
	# 			echo $res
	# 		end
	# 	else
	# 		echo $res
	# 	end
	# end
end
