function insert_aligned -a align insertion string padding -d 'Replace a portion of a string with another string with alignment'

	if test (string match -r '^-?-?h(elp)?$' -- $argv[1])
		echo -e \
"NAME
	insert_aligned - Replace a portion of a string with another string with alignment

SYNOPSIS
	insert ALIGNMENT INSERTION ORIGINAL PADDING

OPTIONS

	-h, --help     - Print this help screen"
		return
	end

	if not set -q padding
		set padding 0
	end

	set rulelen (string length -- "$string")
	set msglen (string length -- "$insertion")

	if test $rulelen -lt (math $msglen+$padding+1)
		echo $insertion
	else
		set -l start
		if test (string match -r '^r' $align)
			set start (math $rulelen-(math $msglen+$padding))
		else if test (string match -r '^c' $align)
			set start (math ceil (math $rulelen/2-(math ceil (math $msglen/2))))
		else
			set start $padding
		end

		echo (insert $start $insertion $string)
	end
end
