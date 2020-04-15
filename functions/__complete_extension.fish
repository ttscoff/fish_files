function __complete_extension
	set -l token (commandline -t)
	/usr/bin/env ruby ~/scripts/filecomplete.rb "$argv" $token
end
