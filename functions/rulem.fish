function rulem -d 'Print a horizontal rule' -a msg char
	set char (fallback $char "-")
	set msg (string replace -a " " "@" $msg)
	set -l cols (tput cols)
	set cols (math $cols-(string length $msg)-6)
	set -l rule (string replace -a " " $char (printf "[@%s@]%*s" $msg $cols " "))
	printf '%s%s%s' $char $char (string replace -a "@" " " $rule)
end
