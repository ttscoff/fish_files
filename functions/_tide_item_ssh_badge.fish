# Adds a badge if we're in an SSH session (first letter of hostname, uppercased)
function _tide_item_ssh_badge
	if test -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY"
		_tide_print_item ssh_badge " "(string upper (string sub -s 1 -l 1 (hostname -s)))" "
	end
end
