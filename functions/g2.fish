# This is an alternative version of jump.fish that uses a
# regex for more liberal fuzzy matching.
#
# A replacement for "jump" from the jump package that handles
# fuzzy subdirectory searching for additional arguments.
#
# Requires that jump be installed (`omf install jump`).
# Then add this file to ~/.config/fish/functions/jump.fish,
# which should override the jump command from the package.
#
# Fist argument must be an existing bookmark, additional
# arguments are searched within the bookmark directory, in
# argument order.
#
# Any part of the directory name can be matched, first
# result is used.
#
# Directory searches go two levels deep.
#
# Arguments can be separated by spaces, or you can use
# slashes (e.g. `jump m/assets/source`).
#
# If the search arguments are all lowercase, the search is
# case insensitive. If an argument contains uppercase
# letters, matching becomes case sensitive.
function g2 -d 'Fish "jump" replacement with fuzzy subdirectory matching'
	set max_depth 2
	set args (string split / $argv)
	if test -d $MARKPATH/$args[1] -a -L $MARKPATH/$args[1]
		set new_path (readlink $MARKPATH/$args[1])
		if test (count $args) -gt 1 # we have more than one argument, search for subdirs
			set needle (__regex_from_args -f $args[2..-1])
			if string match -q --regex [A-Z] $needle
				set case_sensitive "regex"
			else
				set case_sensitive "iregex"
			end
			set max_depth (math $max_depth + (count $args[2..-1]))
			# search for directory containing string up to 2 levels deeper
			set found (find -s -E "$new_path" -$case_sensitive "$needle" -type d -maxdepth $max_depth -mindepth 1 | head -n 1 | tr -d "\n")
			if test -n "$found"
				set found (echo "$found" | sed -e 's/^\.\///')
				# Continue loop using found path as root directory
				set new_path $found
			end
		end
		cd "$new_path"
	else
		echo "No such mark: $argv[1]"
	end
end
