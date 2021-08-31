function ack -d "ack defaults, ~/.ackrc for more"
	printf '%sFind: \033]1337;CopyToClipboard=find\a%s\033]1337;EndCopy\a%s\n' \
		(set_color -d black) \
		"$argv[1]" \
		(set_color normal) >&2
	command ack --smart-case $argv
end
