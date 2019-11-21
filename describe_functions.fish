function describe_functions -d "Create a list of all functions and their descriptions"
	set -l output ""
	for file in functions/*.fish
		set -l cmd (basename $file .fish)
		set -l d (functions -Dv $cmd)
		set -l desc $d[5]
		set -a output "- `$cmd`: $desc"
	end

	printf '%s\n' $output | sort
end
