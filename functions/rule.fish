function rule -d 'Print a horizontal rule'
	set -l char (fallback $argv "-")
	echo (string replace -a " " $char (printf "%*s" (tput cols) " "))
end
