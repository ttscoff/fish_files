# A replacement for "jump" from the jump package that
# handles fuzzy subdirectory searching for additional
# arguments.
#
# Requires that jump be installed (`omf install jump`).
# Then add the following files to ~/.config/fish/functions/,
# which should override the jump command from the package:
#
# - jump.fish
# - ffmark.fish
# - ffdir.fish
# - shortest.fish
#
# Fist argument must be an existing bookmark (also fuzzy
# matched), additional arguments are searched within the
# bookmark directory, in argument order. If the first
# argument is '.', subdirectories will be searched from
# current working directory.
#
# Any part of the directory name can be matched, shortest
# result is used.
#
# Subdirectory search string is separated by slashes or
# spaces. Each segment of the string is a fuzzy directory
# search. Segments can be matched up to two directory levels
# apart.
#
# Assuming a bookmark called "appsupp", linked to
# ~/Library/Application Support
#
#  $ jump apsup m2/css
#
# would match:
#   ~/Library/Application Support/Marked 2/Custom CSS
#
# If the search arguments are all lowercase, the search is
# case insensitive. If an argument contains uppercase
# letters, matching becomes case sensitive. Use -i to force
# case insensitive, or -c to force case sensitive.
function jump -d 'Fish "jump" replacement with subdirectory matching'
	set -l options "I/case-sensitive" "i/case-insensitive" "h/help" "v/verbose" "c/command=" "nomenu" "multi"
	set -l case_sensitive
	set -l cmd
	set -l verbose
	set -l use_fzf ' -m'
	set -l multi ''

	argparse $options -- $argv

	if set -q _flag_nomenu
		set use_fzf ''
	end

	if set -q _flag_multi
		set multi ' --multi'
	end

	if set -q _flag_help || test (count $argv) -eq 0
		echo "Fuzzy jump with subdirectory matching"
		echo
		echo "Usage: jump [MARK] [sub directory search]"
		echo
		echo "- MARK fuzzy matches a link in $MARKPATH"
		echo "- following strings fuzzy match subdirectories"
		echo "- search folders can be separated by space or slash"
		echo "- folder matches can be up to 2 levels deeper than the preceding match"
		echo
		echo "Example:"
		echo "  # where appsupp is an existing jump bookmark"
		echo "  jump appsupp m2 css"
		echo "  => ~/Library/Application Support/Marked 2/Custom CSS"
		echo
		echo "Options:"
		echo "  -c, --command=CMD  - run CMD instead of cd"
		echo "  -I                 - force case sensitive subdirectory matching"
		echo "  -i                 - force case insensitive subdirectory matching"
		echo "  -h                 - display this help"
		return 0
	end

	if set -q _flag_I
		set case_sensitive " -c"
	else if set -q _flag_i
		set case_sensitive " -i"
	end

	if set -q _flag_c
		set cmd $_flag_c
	else
		set cmd "cd"
	end

	if set -q _flag_v
		if functions -q warn
			set verbose "warn"
		else
			set verbose "echo"
		end
	end

	set -l max_depth 2
	set -l regex
	set -l args
	set -l new_path

	# if first arg is '.', search from current directory
	if test "$argv[1]" = '.'
		set new_path (ffdir $use_fzf$multi$case_sensitive . $argv)
		if test -n "$new_path" -a -d "$new_path"

			eval $cmd \"$new_path\"
		else
			echo "No match found"
			return 1
		end
	# if first arg is an exact match for a bookmark
	else if test -d $MARKPATH/$argv[1] -a -L $MARKPATH/$argv[1]
		set new_path (readlink $MARKPATH/$argv[1])
		# we have more than one argument, search for subdirs
		if test (count $argv) -gt 1
			set args $argv[2..-1]
			set new_path (ffdir $use_fzf$multi$case_sensitive $new_path $args)
		end
		# if test -n verbose
		# 	eval $verbose $cmd \"$new_path\"
		# end
		eval $cmd \"$new_path\"
	# no match, fuzzy search bookmarks
	else
		set new_path (ffmark $case_sensitive $argv[1])

		if test -n "$new_path" -a -d "$new_path"
			# if we have more than one argument, search for
			# subdirs
			if test (count $argv) -gt 1
				# set args (string split / (string join "" $argv[2..-1]))
				set args $argv[2..-1]
				set new_path (ffdir $use_fzf$multi$case_sensitive $new_path $args)
			end

			eval $cmd \"$new_path\"
		# if first arg is an actual directory, open that
		else if test -d $argv[1]
			set new_path "$argv[1]"
			if test (count $argv) -gt 1
				set new_path (ffdir $use_fzf$multi$case_sensitive $new_path $argv[2..-1])
			end

			eval $cmd \"$new_path\"
		else
			echo "No such mark: $argv[1]"
		end
	end
end

