# Open a file from a jump bookmark with fuzzy matching
#
# Requires that jump be installed (`omf install jump`). Then
# add the following files to ~/.config/fish/functions/:
#
# - fo.fish
# - ffmark.fish
# - ffdir.fish
# - fffile.fish
# - shortest.fish
#
# Fist argument must be an existing jump bookmark (also
# fuzzy matched), additional arguments are searched within
# the bookmark directory, in argument order. If the first
# argument is '.', subdirectories will be searched from
# current working directory. No arguments opens current
# directory.
#
# Any part of a file name can be matched, shortest result is
# used.
#
# Subdirectory/file search string is separated by slashes or
# spaces. Each segment of the string is a fuzzy
# directory/file search. Segments can be matched up to two
# directory levels apart.
#
# Only the last argument will match a file, and it should
# not contain spaces or it will be interpreted. You can
# match a filename with spaces without including them, e.g.
# "myfile" would fine "my file.md"
#
# Assuming a bookmark called appsupp, linked to
# ~/Library/Application Support
#
# $ fo appsupp m2/css/emma`
#
# would match
#
# ~/Library/Application Support/Marked 2/Custom CSS/Emma.css
#
# If the search arguments are all lowercase, the search is
# case insensitive. If an argument contains uppercase
# letters, matching becomes case sensitive. Use -i to force
# case insensitive, or -c to force case sensitive.
#
# Use -a to specify an alternative app to open. Create an
# alias to change the default:
#
# alias pf='fo -a "Path Finder"' alias fork="fo -a Forklift"
#
# Use -e to change the executable. By default this function
# uses `open`. To use `vim`, for example, use `fo -e vim
# search string`
#
# alias v='fo -e vim'
function fo -d "Open file using jump shortcuts and fuzzy matching"
	set -l options "I/case-sensitive" "i/case-insensitive" "h/help" "v/verbose" "a/app=" "e/executable="

	argparse $options -- $argv

	if set -q _flag_help
		echo "Fuzzy 'jump' to open-in-Finder with subdirectory matching"
		echo
		echo "f [MARK] [sub directory search]"
		echo
		echo "- MARK fuzzy matches a link in $MARKPATH"
		echo "- following strings fuzzy match subdirectories"
		echo "- search folders can be separated by space or slash"
		echo "- folder matches can be up to 2 levels deeper than the preceding match"
		echo
		echo "Example:"
		echo "  # where appsupp is an existing jump bookmark"
		echo "  f appsupp m2 css"
		echo "  => ~/Library/Application Support/Marked 2/Custom CSS"
		echo
		echo "Options:"
		echo "                    -I  force case sensitive subdirectory matching"
		echo "                    -i  force case insensitive subdirectory matching"
		echo "         -a, --app=APP  use APP as alternative to Finder"
		echo "  -e, --executable=EXE  use EXE as alternative to open"
		echo "                    -h  display this help"
		return 0
	end

	set -l case_sensitive
	set -l finder_app
	set -l executable
	set -l verbose

	if set -q _flag_I
		set case_sensitive "-c"
	else if set -q _flag_i
		set case_sensitive "-i"
	end

	if set -q _flag_a
		set finder_app " -a$_flag_a"
	else
		set finder_app ""
	end

	if set -q _flag_v
		if functions -q warn
			set verbose "warn"
		else
			set verbose "echo"
		end
	end

	if set -q _flag_e
		set finder_app ""
		set executable "$_flag_e"
	else
		set executable "open"
	end

	set -l max_depth 2
	set -l regex
	set -l args
	set -l new_path

	# if no args, open the current directory in Finder
	if test (count $argv) -eq 0
		$executable$finder_app "."
	# if first arg is '.', search from current directory
	else if test "$argv[1]" = '.'
		set new_path (fffile $case_sensitive . $argv)
		if test -n "$new_path" -a -f "$new_path"
			$executable$finder_app "$new_path"
		else
			echo "No match found"
			return 1
		end
	# if first arg is an actual file, open that
	else if test -f $argv[1]
		set new_path "$argv[1]"
		if test (count $argv) -gt 1
			set new_path (fffile $case_sensitive $new_path $argv[2..-1])
		end

		$executable$finder_app "$new_path"
	# if first arg is an exact match for a bookmark
	else if test -d $MARKPATH/$argv[1] -a -L $MARKPATH/$argv[1]
		set new_path (readlink $MARKPATH/$argv[1])
		if test (count $argv) -gt 1
		# we have more than one argument, search for subdirs
			set args $argv[2..-1]
			set new_path (fffile $case_sensitive $new_path $args)
		end

		$executable$finder_app "$new_path"
	# no match, fuzzy search bookmarks
	else
		set -l new_path (ffmark $case_sensitive $argv[1])

		if test -n "$new_path" -a -d "$new_path"
			# we have more than one argument, search for subdirs
			if test (count $argv) -gt 1
				# set args (string split / (string join "" $argv[2..-1]))
				set args $argv[2..-1]
				set new_path (fffile $case_sensitive $new_path $args)
			end
			$executable$finder_app "$new_path"
		else
			echo "No such mark: $argv[1]"
		end
	end
end
