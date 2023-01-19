if functions -q expand-word
	expand-word -p '^\d*s/..*/.*$' -e '__substitute_history'
	expand-word -p '^\d*\^..*\^.*$' -e '__substitute_history_caret'
	expand-word -p '^!\d+(?:\.(\d+))?' -e '__get_history'
	expand-word -p '^![^0-9]\w+' -e '__search_history'

	expand-word -p '^//.*/$' -e '__expand_path'
	expand-word -p '^//.*[^/]$' -e '__expand_path'

	function __get_history
		set -l count (string match -r '(\d+)(?:\.(\d+))?' (commandline -t))
		if test -n "$count[3]"
			set -l string_idx (math $count[3] + 1)
			echo -n (__split_history $count[2] $string_idx)
		else
			echo -n "$history[$count[2]]"
		end
	end

	function __split_history
		set -l history_idx $argv[1]
		set -l string_idx $argv[2]
		set -l __old_cmdline (commandline -b)
		commandline $history[$history_idx]
		set -l tokens (commandline -o)
		commandline $__old_cmdline
		printf "%s\n" $tokens[$string_idx]
	end

	function __search_history
		set -l search (string match -r '!(\w+)' (commandline -t))
		history search --contains "$search[2]" --max=15 | head -n 1
	end

	function __substitute_history
		set -l token (commandline -t)
		set -l parts (string match -r '^(\d*)s/(.*?)/(.*?)$' $token)
		set -l count 1
		if test -n "$parts[2]"
			set count $parts[2]
		end
		set -l search $parts[3]
		set -l replace $parts[4]
		echo -n "$history[$count]" | sed -e "s/$search/$replace/g"
	end

	function __substitute_history_caret
		set -l token (commandline -t)
		set -l parts (string match -r '^(\d*)\^(.*?)\^(.*?)$' $token)
		set -l count 1
		if test -n "$parts[2]"
			set count $parts[2]
		end
		set -l search $parts[3]
		set -l replace $parts[4]
		echo -n "$history[$count]" | sed -e "s/$search/$replace/g"
	end

	function __expand_path
		set -l token (commandline -t)
		set -l search (remove_empty (string split " " (string replace -a '/' ' ' $token)))
		set -l process (commandline -p)
		set -l res

		if test (string match -r '/$' $token) || test (string match -r '^\s*cd ' $process)
			set res (ffdir -d2 . $search)

			if test -z "$res" || test (string match -r '^\.$' $res)
				set res (shortest (fasd -tldR0 $search| head -n 5 | awk '{print $0}'))
			end
		else
			set res (fffile -d2 . $search)
			if test -z "$res" || test (string match -r '^\.$' $res)
				set res (shortest (fasd -tlR0 $search| head -n 5 | awk '{print $0}'))
			end
		end

		if test -z "$res" || test (string match -r '^\.$' $res)
			return 1
		else
			ls -pd $res
		end
	end
end
