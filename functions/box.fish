# Draws a single line box around the given text. Box will
# always be default foreground, but you can pass a colorized
# string.
function box -d 'Draw a box around text.'
	echo (set_color normal)"┌"(echo "$argv  " | uncolor | sed -E 's/./─/g')"┐"
	echo "│ "(set_color normal)"$argv"(set_color normal)" │"
	echo (set_color normal)"└"(echo "$argv  " | uncolor | sed -E 's/./─/g')"┘"
end
