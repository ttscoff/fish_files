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
	test -s (basename $PWD)".taskpaper" && ~/scripts/fish/na
end
