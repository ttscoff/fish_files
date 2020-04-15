# ~/.config/fish/completions/tm.fish
function __tm_has_no_args
	set -l cmd (commandline -opc)
	echo $cmd
	return (test (count $cmd) -eq 1)
end

function __tm_has_windows
	set -l cmd (commandline -opc)
	set -l res (tmux list-windows -t $cmd[-1] 2>/dev/null >/dev/null)
	return $status
end

function __tm_list_windows
	set -l cmd (commandline -opc)
	tmux list-windows -t $cmd[-1] -F "#W" 2>/dev/null
end

complete -x -c tm -n '__tm_has_windows' -a '(__tm_list_windows)'
complete -x -c tm -n '__tm_has_no_args' -a "(tmux -q list-sessions -F '#S' 2> /dev/null)"
