function insert -a start insertion string -d 'Insert a string in another string at start position'
	if test (string match -r '^-?-?h(elp)?$' -- $argv[1])
		echo -e \
"NAME
	insert - Replace a portion of a string with another string at a given start point

SYNOPSIS
	insert START INSERTION ORIGINAL

OPTIONS

	-h, --help     - Print this help screen"
		return
	end

	set msglen (string length -- "$insertion")
	set rx '^(.{'$start'}).{'$msglen'}(.*?)$'
	echo (string replace -r $rx -- '$1'$insertion'$2' $string)
end
