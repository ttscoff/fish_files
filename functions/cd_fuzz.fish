function cd_fuzz
	if test (count $argv) -eq 1 && test -e $argv[1]
		__original_cd $argv
	else
		set path (__fish_complete_path $argv)[1]
		__fuzzy_cd $argv
	end
	return 0
end

function __fuzzy_cd
	set -l res
	set -l token (string split " " (string replace -a "/" " " (string join "/" $argv)))
	set -l first_token $token[1]

	# See if first position is a match for a jump bookmark
	set -l base (ffmark $first_token)
	if test -n "$base"
		set -e token[1]
	else
		set base '.'
	end

	set res (ffdir -d1 --multi $base $token)

	if test -z "$res" || test (string match "." $res)
		set -l search
		if test (string match "." $base)
			set search $token
		else
			set search $base $token
		end

		set res (fasd -tldR0 $search| head -n 5 | awk '{print $0}')
	end

	set -l result (shortest $res)

	if test -n "$result"
		__original_cd (string escape $result)
	end
end
