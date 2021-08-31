function __ff_dir_to_regex
	echo (printf '%s' (echo "$argv"|sed -E 's/ +//g'|sed -E 's/(.)/\1[^\/]*/g'))
end

function __ff_dir_regex
	set -l section
	set -l regex (__f_dir_to_regex $argv[1])
	for arg in $argv[2..-1]
		set section (__f_dir_to_regex $arg)
		set regex "$regex/[^.]*$section"
	end
	echo $regex
end

function ffdir -d "fuzzy find a directory, pass root dir and sequential search strings"
	set -l options "c/case-sensitive" "i/case-insensitive"
	argparse $options -- $argv

	set -l max_depth 2
	set -l new_path
	set -l args
	if test (count $argv) -gt 1
		set new_path $argv[1]
		set args $argv[2..-1]
	else
		set new_path '.'
		set args $argv
	end

	if test (count $args) -gt 0
		# allow traversing to number of args * max count
		set max_depth (math (count $args)" * $max_depth")
		set -l found "."
		# if search string contains uppercase, make search case sensitive
		if string match -q --regex [A-Z] $args or set -q _flag_c
			set case_sensitive "regex"
		else
			set case_sensitive "iregex"
		end
		# search for directory containing string up to 2 levels deeper
		set -l regex (__f_dir_regex $args)
		# start by looking for directories starting with first char of search
		# string, ignoring dot directories
		set -l results (find -E -s "$new_path" -$case_sensitive ".*/[^.]*$regex.*" -type d -maxdepth $max_depth -mindepth 1)
		# choose shortest result
		set found (shortest $results)

		# if we found a result, clean it up
		if test -n "$found"
			set found (echo "$found" | sed -e 's/^\.\///')
			set new_path $found
		else # if not, try again without the first char/dot requirement
			set results (find -E -s "$new_path" -$case_sensitive ".*$regex.*" -type d -maxdepth $max_depth -mindepth 1)
			set found (shortest $results)
			if test -n "$found"
				set found (echo "$found" | sed -e 's/^\.\///')
				set new_path $found
			end
		end
	end
	echo "$new_path"
end
