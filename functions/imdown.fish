function __nag
	while true
		for phrase in $argv
			afplay /System/Library/Sounds/Ping.aiff
			say $phrase
			sleep 10
		end
	end
end

function __pushnotify
	set -l token aykacu2y8qv98ikmm96my6q89y23z6
	set -l key o2WU1702cqrw9vLcNClzdR7eJ268g7
	set -l formdata "token=$token&user=$key&title="(urlenc $argv[1])"&message="(urlenc $argv[2])"&priority=1&sound=spacealarm"
	curl -X POST -d $formdata 'https://api.pushover.net/1/messages.json'
end

function imdown -d 'Test for internet connection and notify when it comes up'
	while ! ping -W1 -c1 8.8.8.8 >/dev/null 2>/dev/null
		sleep 5
	end
	__pushnotify "Internet connection restored" "Your internet connection is operational again"
	__nag \
		"internet connection is back up\!" \
		"Skynet is thinking" "your tribulation is over\!" \
		"Praise what gods may be. internet\!" \
		"O M G we're online" \
		"In the words of Dr. Frankenstein, it's alive\!"
end
