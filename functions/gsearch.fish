function gsearch -d 'Grep git commit history'
	git log -g --grep="$argv"
end
