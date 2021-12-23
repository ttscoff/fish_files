function corner_print
	set -l options 'tl' 'tr' 'bl' 'br' 'help'
	argparse $options -- $argv

	set -l message (string join " " $argv)
	set -l len (count (string split "" $message))

	if set -q _flag_help
		echo "Print to a corner of the screen"
		echo "Options:"
		echo "  --bl  Bottom left"
		echo "  --br  Bottom right"
		echo "  --tl  Top left"
		echo "  --tr  Top right"
		return
	end

	stty size | read y x
	tput sc
	if set -q _flag_tl
		tput cup 1 0
	else if set -q _flag_tr
		tput cup 1 (math "$x - $len")
	else if set -q _flag_bl
		tput cup (math "$y - 2") 0
	else
		tput cup (math "$y - 2") (math "$x - $len")
	end

	printf '%s' $message >&2
	tput rc
end
