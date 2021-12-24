function __fuzzy_cd -d "fuzzy cd with jump bookmarks"
	function __fuzzy_cd_chdir
		set -l res
		set -l first_token $argv[1]
		set -l tokens (string split " " (string replace -a "/" " " (string join "/" $argv)))
		set -l try_mark true

		# if the first token contains a non alphanumeric symbol, don't match a jump mark
		if string match -q -r -- '[^A-Za-z0-9]' $first_token
			set try_mark false
		end

		set -l token
		for dir in $tokens
			switch $dir
			case '.'
				command cd .
			case '..'
				command cd ..
			case '*'
				set -a token $dir
			end
		end

		if $try_mark
			# See if first position is a match for a jump bookmark
			set -l base (ffmark $first_token)
			if test -n "$base"
				set -e token[1]
			else
				set base '.'
			end

			if test (count $token) -eq 0
				__fuzzy_wrapped_cd $base
				return 0
			end

			set res (ffdir -i -d2 --multi $base $token)
		end

		if test -z "$res" || test (string match '.' $res) || test (string match $base $res)
			# switch to using fasd, keeping the base if we matched a jump mark
			set -l search
			if test (string match "." $base)
				set search $token
			else
				set search $base $token
			end

			set res (fasd -tldR0 $search| head -n 5 | awk '{print $0}')
		end


		# set -l result (shortest $res)
		set -l result (printf "%s\n" $res | fzf -1 -0 --height=8 --info=inline --tiebreak=begin,length)

		if test -n "$result"
			__fuzzy_wrapped_cd $result
		else
			if not $try_mark
				__fuzzy_cd_chdir $token
			end
		end
	end

	if test -z "$argv"
		__fuzzy_wrapped_cd
	else if string match '-' "$argv"
		__fuzzy_wrapped_cd -
	else if test (count $argv) -eq 1 && test -e $argv[1]
		__fuzzy_wrapped_cd $argv
	else
		__fuzzy_cd_chdir $argv
	end
end
