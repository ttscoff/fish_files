function ag -d "Silver Surfer defaults, smart case, ignore VCS"
	printf '%sFind: \033]1337;CopyToClipboard=find\a%s\033]1337;EndCopy\a%s\n' \
		(set_color -d black) \
		"$argv[1]" \
		(set_color normal) >&2
	command ag -SU $argv
end
