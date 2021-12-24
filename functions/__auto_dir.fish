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
			set fmatch (printf "%s\n" $dirs|fzf --height=(math (count $dirs) + 1))
		else if test (count $dirs) -eq 1
			set fmatch $dirs
		else
			__fish_default_command_not_found_handler $argv
		end

		if test -d $fmatch
			warn "cd $fmatch"
			cd "$fmatch"
		else if test -x $argv[1]
			warn "execute $argv"
			eval "./$argv"
		else
			__fish_default_command_not_found_handler $argv
		end

		return 0
	end
end
