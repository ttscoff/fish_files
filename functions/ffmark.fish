function __ff_mark_to_regex
	echo (printf '%s' (echo "$argv"|sed -E 's/ +//g'|sed -E 's/(.)/\1[^\/]*/g'))
end

function __ff_mark_regex
	set -l section
	set -l regex (__ff_mark_to_regex $argv[1])
	for arg in $argv[2..-1]
		set section (__ff_mark_to_regex $arg)
		set regex "$regex/.*$section"
	end
	echo $regex
end

function ffmark -d "fuzzy find a jump mark"
	if test -e ~/.marks/$argv[1]
		echo -n (readlink ~/.marks/$argv[1])
		return 0
	end

	set -l new_path
	if test (count $argv) -gt 0
		set -l args $argv
		set -l found
		set -l case_sensitive

		set -l regex (__ff_mark_regex $args)

		# Search .marks
		set -l results (find -LE -s "$MARKPATH" -iregex "$MARKPATH/$regex" -type d -maxdepth 1 | head -n 1 | tr -d "\n")
		# Get shortest match
		set found (shortest $results)

		if test -n "$found"
			set found (string replace -r '^./' '' $found)
			set new_path $found
		else
			set -l results (find -LE -s "$MARKPATH" -iregex "$MARKPATH/.*$regex" -type d -maxdepth 1 | head -n 1 | tr -d "\n")
			# Get shortest match
			set found (shortest $results)
			if test -n "$found"
				set found (string replace -r '^./' '' $found)
				set new_path $found
			end
		end
	end
	echo -n (readlink "$new_path")
end


