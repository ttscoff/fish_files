alias src="source ~/.config/fish/config.fish"

alias ...="cd ../.."
alias ....="cd ../../.."

alias c="clear"
alias cbp="pbpaste | cat"

function gist -d "gist is defunkt, use jist"
	jist -p -c $argv
end
function gistp -d "private gist"
	jist -c $argv
end
function pbgist -d "public gist from clipboard"
	jist -pcP $argv
end
function pbgistp -d "private gist from clipboard"
	jist -cP $argv
end

alias npmg="npm install -g"
