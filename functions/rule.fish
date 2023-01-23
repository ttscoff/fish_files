# requires insert and insert_aligned
# accepts any number of characters for --character
# --align left/right/center
# adjust padding with --padding
# run with or without message
function __rule_only -a char
	set -l charlen (string length -- "$char")
	set -l rule (string replace -a " " -- "$char" (printf '%*s' (math floor (math (tput cols)/$charlen)) " "))
	set -l remainder (math floor (math (tput cols)-(string length -- "$rule")))

	set -l suffix ''
	if test $remainder -gt 0
		set -l tail (string replace -a " " -- "$char" (printf '%*s' $remainder " "))
		set suffix (string join '' (string split '' -f1-$remainder -- $tail))
	end
	printf '%s%s' $rule $suffix
end

function rule -d 'Print a horizontal rule with optional message'

	argparse --name=rule 'h/help' 'c/character=' 't/thick' 'a/align=' 'p/padding=' -- $argv

	if set -q _flag_help
		echo -e \
"NAME
	rule - Print a horizontal rule containing an optional message

SYNOPSIS
	rulem [OPTIONS] [MESSAGE]

OPTIONS
	-a, --align      - align left, center, right
	-c, --character  - Character(s) to use to draw the horizontal rule
	-p, --padding    - padding for left/right align
	-t, --thick      - Print 3-row rule
	-h, --help       - Display help"
		return
	end

	set char (fallback $_flag_character "-")
	set padding (fallback $_flag_padding 2)
	set align (fallback $_flag_align "left")
	set charlen (string length -- "$char")

	if test (count $argv) -gt 0
		set rule (__rule_only "$char")
		set msg "[ "(string join " " $argv)" ]"
		set msgrule (insert_aligned $align $msg $rule $padding)

		if set -q _flag_thick
			echo $rule
		end
		echo $msgrule
		if set -q _flag_thick
			echo $rule
		end
	else
		if set -q _flag_thick
			__rule_only "$char"
		end
		__rule_only "$char"
		if set -q _flag_thick
			__rule_only "$char"
		end
	end
end
