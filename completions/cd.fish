complete -x -c cd -n '__should_complete_cd' -a '(__complete_cd)'
complete -Fk -c cd -n '__should_complete_mark' -a '(command ls -1 ~/.marks)'

function __should_complete_mark
	test (count (commandline -o -b)) -lt 3
end

function __should_complete_cd
	test (count (commandline -o -b)) -gt 2
		and test not (string match -r '^\.{2,}' (commandline -t))
end

function __complete_cd
	set -l res
	set -l original (commandline -b)
	set -l token (commandline -o -b)[2..-1]

	set token (string split "/" (string trim (string replace -a '/' ' ' $token)))

	# See if first position is a match for a jump bookmark
	set -l base (ffmark $token[1])

	if test -n "$base"
		set -e token[1]
	else
		set base '.'
	end

	# if test (count $token) -eq 0
	# 	printf "%s\tJump shortcut\n" (string escape (trim_pwd (ls -dp "$base")))
	# end
	#

	# first test for a subdirectory match
	set res (ffdir -d1 --multi -- $base $token)

	# if no match is found from the current directory
	if test (string match -r '^./?$' $res)
		set res ''
	end

	if test -z "$res"
		set res (fasd -tldR0 $token| head -n 5 | awk '{print $0}')
	end

	if test -z "$res"
		return 0
	end

	for dir in $res
		echo (string replace $base/ '' $dir)
	end

	# set res (map trim_pwd $res)
	# # set -l result (shortest $res)
	# set -l result (echo -e (string join "\n" $res) | __sort_by_length | head -n 5 | fzf -1 -0 --height 5)
	# if test -n "$result"
	# 	commandline -r -- "cd "
	# 	commandline -i -- (string escape (ls -dp $result))
	# else
	# 	commandline -r $original
	# end

	# commandline -f repaint
	# return 0
end
