# adapted from https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
function slugify
	echo $argv | LC_ALL=C command iconv -t ascii//TRANSLIT | LC_ALL=C command sed -E 's/[^a-zA-Z0-9\-]+/_/g' | LC_ALL=C command sed -E 's/^(-|_)+|(-|_)+$//g'
end

# Slugify you can pipe to
function to_slug
	cat | LC_ALL=C command iconv -t ascii//TRANSLIT | LC_ALL=C command sed -E 's/[^a-zA-Z0-9\-]+/_/g' | LC_ALL=C command sed -E 's/^(-|_)+|(-|_)+$//g'
end

function shortest_common
	set -l root $argv[1]
	set -l results $argv[1]
	set -e argv[1]
	for path in (return_array $argv | sort)
		if not test (string match "$root*" $path)
			set root $path
			set -a results $path
		end
	end
	return_array $results
end

function __ff_dir_to_regex
	echo (printf '%s' (echo "$argv"|sed -E 's/ +//g'|sed -E 's/(.)/\1[^\/]*/g'))
end

function __ff_dir_regex
	set -l section
	set -l regex (__ff_dir_to_regex $argv[1])
	for arg in $argv[2..-1]
		set section (__ff_dir_to_regex $arg)
		set regex "$regex/[^.]*$section"
	end
	echo $regex
end

function __should_na --on-variable PWD
	# function __should_na --on-event fish_prompt
	test -s (basename $PWD)".taskpaper" && na
end

function __sort_by_length
	set lines (string join "\n" $argv)
	echo -e $lines | awk '{ print length(), $0 | "sort -n" }' | cut -d" " -f2-
end

function __by_length
	cat | awk '{ print length(), $0 | "sort -n" }' | cut -d" " -f2-
end

function map
	set fnc $argv[1]
	set args $argv[2..-1]
	if test -z "$args"
		while read item
			echo (eval $fnc (string escape $item))
		end
	else
		set -l result

		for item in $args
			set -a result (eval $fnc (string escape $item))
		end

		echo -en (string join "\n" $result)
	end
end

function remove_empty -d 'removes empty elements from an array'
	set -l result
	for item in $argv
		if test -n (string replace -a ' ' '' $item)
			set -a result $item
		end
	end
	echo -en (string join "\n" $result)
end

function trim_pwd -d 'removes the current working directory from an array of paths'
	set -l wd (pwd)
	if test (count $argv) -gt 0
		echo -en $argv | sed -E "s%^($wd|\.)/%%" | sed -E "s%^$wd/?\$%.%"
	else
		while read line
			echo -e $line | sed -E "s%^($wd|\.)/%%" | sed -E "s%^$wd/?\$%.%"
		end
	end
end

function return_array -d 'Echo out an array one line at a time'
	for item in $argv
		echo $item
	end
end

function shorten_home -d 'substitutes $HOME with ~'
	set -l wd $HOME
	if test (count $argv) -gt 0
		echo -en $argv | sed -E "s%^$wd%~%"
	else
		while read line
			echo -e $line | sed -E "s%^$wd%~%"
		end
	end
end

function append_slash -d 'append a slash to each line/argument if needed'
	if test (count $argv) -gt 0
		echo -en $argv | sed -E 's%/?$%/%'
	else
		while read line
			echo -e $line | sed -E 's%/?$%/%'
		end
	end
end


function slash_if_dir -d 'Add trailing slash if directory'
	if test -d $argv
		append_slash $argv
	else
		echo -en $argv
	end
end
