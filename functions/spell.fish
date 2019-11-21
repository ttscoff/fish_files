function spell -d "Get spelling options from aspell"
	for word in $argv
		set -l results (echo -en "$word"|aspell pipe|tail -n 2|head -n 1|sed -E 's/[^:]+: //'|sed -E 's/, / /g'|sed -E 's/([[:alpha:]]+\'[[:alpha:]]*( |$)|\*)//g')
		printf '%s\n' (string split " " $results) | head -n 5
	end
end
