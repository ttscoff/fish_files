function unbak -d "remove bak extension"
	set -l options (fish_opt -s c -l copy)
	set options $options (fish_opt -s h -l help)

	argparse --name=unbak $options -- $argv

	if set -q _flag_help
		echo "NAME"
		echo "    unbak - Restore a .bak to original filename"
		echo
		echo "SYNOPSIS"
		echo "    unbak [OPTIONS] FILE"
		echo
		echo "OPTIONS"
		echo "    -c, --copy  - Copy the file to original name (default move)"
		echo "    -h, --help  - Display help"
		return
	end
	set -l filename $argv[1]
	set -l unbakd (string replace -r '(\.\d{4}-\d{2}-\d{2}_\d{2}\.\d{2}\.\d{2})?\.bak$' "" $filename)
	if set -q _flag_copy
		cp -r $filename $unbakd
	else
		mv $filename $unbakd
	end
end
