function shorten
	set -l options "l/left" "h/help" "e/ellipsis=?"
	set -l ellipsis ""
	argparse $options -- $argv

	if set -q _flag_help
		echo "cat | shorten [--left] [--ellipsis[=...]] WIDTH"
		return 0
	end

	if set -q _flag_ellipsis
		if test -z $_flag_ellipsis
			set ellipsis "…"
		else
			set ellipsis $_flag_ellipsis
		end
	end

	if set -q _flag_left
		command cat | sed -E 's/.*(.{'(fallback $argv 78)'})$/'$ellipsis'\1/'
	else
		command cat | sed -E 's/(.{'(fallback $argv 78)'}).*$/\1'$ellipsis'/'
	end
end
