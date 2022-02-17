function ffdir -d "fuzzy find a directory, pass root dir and sequential search strings"
	set -l options "c/case-sensitive" "i/case-insensitive" "m/menu" "multi" "d/depth=" "shortest"
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

	if set -q _flag_depth
		set max_depth $_flag_depth
	end


	if test (count $args) -gt 0
		# allow traversing to number of args * max count
		set max_depth (math (count $args)" * $max_depth")
		test $max_depth -gt 4 && set max_depth 4
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
		set -l results (find -E -s "$new_path" -$case_sensitive ".*/[^.]*$regex.*" -type d -maxdepth $max_depth -mindepth 1 2> /dev/null)
		# choose shortest result
		if set -q _flag_menu
			set found (echo -e (string join "\n" $results) | fzf -1 -0)
			if test -z "$found"
				return
			end
		else
			if set -q _flag_multi
				set found $results
			else
				set found (shortest $results)
			end
		end

		# if we found a result, clean it up
		if test -n "$found"
			if set -q _flag_multi
				if set -q _flag_shortest
					set found (shortest_common $found)
				end
				return_array $found
				return
			end
			set found (echo -n "$found" | sed -e 's/^\.\///')
			set new_path $found
		else # if not, try again without the first char/dot requirement
			set results (find -E -s "$new_path" -$case_sensitive ".*$regex.*" -type d -maxdepth $max_depth -mindepth 1 2> /dev/null)
			if set -q _flag_shortest
				set results (shortest_common $results)
			end
			if set -q _flag_menu
				set found (return_array $results | fzf -1 -0)
				if test -z "$found"
					return
				end
			else
				if set -q _flag_multi
					set found $results
				else
					set found (shortest $results)
				end
			end
			if test -n "$found"
				if set -q _flag_multi
					echo -e (string join "\n" $found)
					return
				end
				set found (echo "$found" | sed -e 's/^\.\///')
				set new_path $found
			end
		end
	end
	echo "$new_path"
end
