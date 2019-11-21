function __prev_token -d 'Get the previous token on the command line'
	set -l buffer (commandline -bo)
	commandline -a " "$buffer[-1]
	commandline -f end-of-line
end
