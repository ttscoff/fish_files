function badge -d 'Set iTerm session badge'
	printf "\e]1337;SetBadgeFormat=%s\a" (echo -n "$argv" | base64)
end
