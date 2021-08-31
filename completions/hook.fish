function __fish_hook_needs_command
	# Figure out if the current invocation already has a command.

	set -l opts h-help v-version
	set cmd (commandline -opc)
	set -e cmd[1]
	argparse -s $opts -- $cmd 2>/dev/null
	or return 0
	# These flags function as commands, effectively.
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_hook_using_command
	set -l cmd (__fish_hook_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd $argv
	and return 0
end

function __fish_hook_subcommands
	hook help -c
end

complete -xc hook -n '__fish_hook_needs_command' -a '(__fish_hook_subcommands)'
