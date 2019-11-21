function fp -d 'Find and list processes matching a case-insensitive fuzzy-match string'
	set -l options "f/fuzzy"

	argparse $options -- $argv

	set -l needle $argv
	if set -q _flag_fuzzy
		set needle (__regex_from_args -f $needle)
	end

	ps Ao pid,comm | awk '{match($0,/[^\/]+$/); print substr($0,RSTART,RLENGTH)": "$1}' | grep -iE $needle | grep -v grep
end
