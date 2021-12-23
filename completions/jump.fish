complete -c jump -f -a '(__complete_jump)'

function __complete_jump
	if test (count (commandline -o -b)) -lt 3
		command ls ~/.marks
	else
		set -l words (commandline -o -b)
		commandline -r "$words[1..2] $words[-1]"
		commandline -f repaint
		set -l mark_path (ffmark $case_sensitive $words[2])
		jump --nomenu --multi -c 'echo -e' $words[2..-1] | sed -e "s|^$mark_path/||"
		# string join "\n" $res
		# commandline -r "cd "(jump -c 'echo -n' $words[2] $words[-1])
	end
end
