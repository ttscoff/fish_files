function watchthis -d 'Watch for changes in the current directory and execute command'
	watchmedo shell-command --recursive --command="$argv"
end
