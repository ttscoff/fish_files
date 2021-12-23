function __expand_path -d 'commandline function to expand str/str using fasd and fzf'
	set -l options "nofzf"

	argparse $options -- $argv

	set -l res

	# if the token is s/str/str then do a history replace instead of path expansion
	if test (string match --regex '^s/.*/.*$' (commandline -b))
		set res (echo -n "$history[1]" | sed -e (commandline -t)/g)
		commandline -t ''
		commandline -it -- $res
		return
	end

	set -l token (commandline -o -t)
	set -l process (commandline -o -p)[1]
	set -l dir_only false
	set -l replace_line false

	if test -z (commandline -t)
		set token (commandline -o -p)[2..-1]
		set replace_line true
	end

	set token (string split " " (string replace -a "/" " " (string join "/" $token)))

	# If the job ends with / or the command is cd, search directories only
	if test (string match -r '/\s*$' (commandline -p)) || test (string match 'cd' $process)
		set dir_only true
	end

	# See if first position is a match for a jump bookmark
	set -l base (ffmark $token[1])
	if test -n "$base"
		set -e token[1]
	else
		set base '.'
	end

	if test -n (commandline -t)
		# search current subdirectories for match
		if $dir_only
			set res (ffdir -d1 --multi $base $token)
		else
			set res (fffile -d1 --multi $base $token)
		end
		# if no match is found from the current directory
		if test (string match '.' $res)
			set res
		end
	end

	if test -z "$res"
		set -l args
		if $dir_only
			set args 'tldR0'
		else
			set args 'tlR0'
		end

		set -a res (fasd -$args $token| head -n 5 | awk '{print $0}')
	end

	set -l result

	if set -q _flag_nofzf
		set result (__by_length $res)
		set result $result[1]
	else
		set result (echo -e (string join "\n" $res) | fzf -1 -0 --height 5)
	end

	if test -n "$result"
		if $replace_line
			commandline -r $process" "
		end
		commandline -t ''
		commandline -it -- (string escape (command ls -dp "$result" | trim_pwd))
	end

	commandline -f repaint
end
