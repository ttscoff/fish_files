# Adds a badge if we're in an SSH session (first letter of hostname, uppercased)
function _tide_item_message
	set -l message $_prompt_message
	set -U _prompt_message ''
	_tide_print_item message (set_color -b $tide_message_bg_color; set_color $tide_message_color) $message
end
