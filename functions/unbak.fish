function unbak -d "remove bak extension"
	set -l options (fish_opt -s c -l copy)
	set options $options (fish_opt -s h -l help)

	argparse --name=unbak $options -- $argv

	if set -q _flag_help
		echo -e \
"NAME
	unbak - Restore a .bak to original filename
		echo
SYNOPSIS
	unbak [OPTIONS] FILE
		echo
OPTIONS
	-c, --copy  - Copy the file to original name (default move)
	-h, --help  - Display help"
		return
	end
	for filename in $argv
		set filename (echo $filename | sed 's/\/*$//')
		set -l unbakd (string replace -r '(\.\d{4}-\d{2}-\d{2}_\d{2}\.\d{2}\.\d{2})?\.bak$' "" $filename)
		if set -q _flag_copy
			cp -r $filename $unbakd
		else
			mv $filename $unbakd
		end
	end
end
