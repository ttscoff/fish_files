function __complete_extension -d "Complete extension with filecomplete.rb"
    set -l token (commandline -t)
    /usr/bin/env ruby ~/scripts/filecomplete.rb "$argv" $token
end
