function shortest -d 'Return the shortest string in array'
	set -l args
	if not tty >/dev/null
		read args
	else
		set args $argv
	end

	set -l lines
	for str in $args
		if test (string length $str) -gt 0
			set lines $lines "$str"
		end
	end

	for line in $lines
		echo (string length "$line") "$line"
	end | sort -n | head -1 | cut -d' ' -f2-
end
