function __unfuck_previous_command
	switch (commandline -t)
	case "??"
	env THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $history[1] 2> /dev/null | read fuck
	if [ -z $fuck ]
		commandline -i '?'
	else
		commandline -r $fuck
	end
	case "*"
	commandline -i '?'
	end
end
