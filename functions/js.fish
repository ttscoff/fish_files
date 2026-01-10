function js -d 'lint with jslint'
	jsl -conf ~/jslint.conf -process "$argv" \
		| sed -E 's/(.+)\(([0-9]+)\):/\1:\2/g' \
		| colout '^\S+\.\w+$' green bold \
		| colout '(\d) ((?:error|warning)\(s\))' red,magenta \
		| colout '(?:lint )?warning:.*$' yellow \
		| colout '(?:\d+) (.*[Ee]rror:.*)$' red \
		| colout '^(\.*)(\^)' black,green bold,bold \
		| colout '^(\/.*?)([^\/]+\.\S+)(:\d+) ' black,green,green bold,bold,normal
end
