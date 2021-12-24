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
			set found (echo "$found" | sed -e 's/^\.\///')
			set new_path $found
		else
			set -l results (find -LE -s "$MARKPATH" -iregex "$MARKPATH/.*$regex" -type d -maxdepth 1 | head -n 1 | tr -d "\n")
			# Get shortest match
			set found (shortest $results)
			if test -n "$found"
				set found (echo "$found" | sed -e 's/^\.\///')
				set new_path $found
			end
		end
	end
	echo -n (readlink "$new_path")
end


