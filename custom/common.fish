function __should_na --on-variable PWD
	test -s (basename $PWD)".taskpaper" && ~/scripts/fish/na
end

function __exec_available
	set -l res (type $argv >/dev/null 2>/dev/null; echo $status)
	if test $res -eq 0
		return 0
	else
		return 1
	end
end

function __best_pager
	if test -n "$PAGER"
		echo $PAGER
		return 0
	else
		set -l pagers bat less more
		for pg in $pagers
			if __exec_available $pg
				echo $pg
				return 0
			end
		end
	end
	echo "more"
end

function fallback --description 'allow a fallback value for variable'
	if test (count $argv) = 1
		echo $argv
	else
		echo $argv[1..-2]
	end
end

function get_ext --description "Get the file extension from the argument"
	set -l splits (string split "." $argv)
	echo $splits[-1]
end
