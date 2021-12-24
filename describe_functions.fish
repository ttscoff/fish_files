#!/usr/local/bin/fish

function describe_functions -d "Create a list of all functions and their descriptions"
	set -l output ""

	for file in functions/*.fish
		set -l cmd (basename $file .fish)
		set -l d (functions -Dv $cmd)
		set -l desc $d[5]
		set -a output "- `$cmd`: $desc"
	end

	set -l utility_output ""

	for func in (cat conf.d/common.fish | grep -i '^function' | awk '{print $2}')
		set -l d (functions -Dv $func)
		set -l desc $d[5]
		set -a utility_output "- `$func`: $desc"
	end

	printf '%s\n' $output | sort

	echo
	echo '### Utility functions'

	printf '%s\n' $utility_output | sort
end

describe_functions
