
function __regex_from_args -d 'Helper to create greedy regular expression from multiple arguments'
	set -l options "f/fuzzy"

	argparse $options -- $argv

	if set -q _flag_fuzzy
		printf '.*%s' (echo "$argv"|sed -E 's/ +//g'|sed -E 's/(.)/\1.*/g')
	else
		echo "$argv" | sed -E 's/ /.*/g'
	end
end
