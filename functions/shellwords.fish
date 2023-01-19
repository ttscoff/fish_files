function shellwords -d 'Split a string like a shell would'
	set -l __old_cmdline (commandline -b)
	commandline $argv
	set -l tokens (commandline -o)
	commandline $__old_cmdline
	printf "%s\n" $tokens
end
