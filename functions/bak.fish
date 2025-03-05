function bak -d "Back up a file by moving or copying to FILE.bak"
	set -l options (fish_opt -s c -l copy)
	set options $options (fish_opt -s d -l date)
	set options $options (fish_opt -s h -l help)

	argparse --name=bak $options -- $argv

	if set -q _flag_help
		echo -e \
"NAME
	unbak - Make a .bak backup of a file

SYNOPSIS
	bak [OPTIONS] FILE

OPTIONS
	-c, --copy  - Create a copy of the file (default move)
	-d, --date  - Timestamp the backup
	-h, --help  - Display help"
		return
	end

	for filename in $argv
		set filename (echo $filename | sed 's/\/*$//')
		set -l extension
		if set -q _flag_date
			set extension "."(date +%Y-%m-%d_%H.%M.%S)".bak"
		else
			set extension ".bak"
		end

		if set -q _flag_copy
			cp -r "$filename" "$filename$extension"
		else
			mv "$filename" "$filename$extension"
		end
	end
end
