function __auto_dir --on-event fish_command_not_found -d "if command fails see if it's a directory or local executable"
	set -l cmd $argv[1]
	set -l fmatch (ls -1|grep --color=never -i -e "$cmd.*")
	if test $status -eq 0
		set -l dirs
		for i in $fmatch
			if test -d $i
				set -a dirs $i
			end
		end
		if test (count $dirs) -gt 1
			set fmatch (printf "%s\n" $dirs|fzf)
		else if test (count $dirs) -eq 1
			set fmatch $dirs
		else
			return
		end
		set_color -o green
		if test -d $fmatch
			echo "cd $fmatch"
			cd "$fmatch"
		else if test -x $argv[1]
			echo "execute $argv"
			eval "./$argv"
		else
			echo "Found $fmatch, but I don't know what to do with it."
		end
	end
end
