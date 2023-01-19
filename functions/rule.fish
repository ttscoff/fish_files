function rule -d 'Print a horizontal rule'

end


function rule -d 'Print a horizontal rule with optional message'

	argparse --name=rule 'h/help' 'c/character=' -- $argv

	if set -q _flag_help
		echo -e \
"NAME
	rule - Print a horizontal rule containing an optional message

SYNOPSIS
	rulem [OPTIONS] [MESSAGE]

OPTIONS
	-c, --character  - Character(s) to use to draw the horizontal rule
	-h, --help  - Display help"
		return
	end

	set char (fallback $_flag_character "-")
	set charlen (string length $char)
	if test (count $argv) -gt 0
		set msg (string replace -a " " "@" (string join " " $argv))
		set msglen (math (string length $msg)+6)
		set -l cols (math (tput cols)-$msglen)
		set cols (math floor (math $cols/$charlen))
		set -l rule (string replace -a " " $char (printf "[@%s@]%*s" $msg $cols " "))
		set -l prefix (string replace -r '(..).*?$' '$1' -- $char$char)
		set -l remainder (math floor (math (tput cols)-(string length $rule)-2))
		set -l suffix ''
		if test $remainder -gt 0
			set -l tail (string replace -a " " $char (printf '%*s' $remainder " "))
			set suffix (string join '' (string split '' $tail -f1-$remainder))
		end

		printf '%s%s%s' $prefix (string replace -a "@" " " $rule) $suffix
	else
		echo (string replace -a " " $char (printf "%*s" (math floor (math (tput cols)/$charlen)) " "))
	end
end
