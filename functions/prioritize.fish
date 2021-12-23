function prioritize -d 'set a numeric prefix on a file for sorting'
	if test (count $argv) -ne 2
		echo "Usage: prioritize FILENAME PRIORITY"
		echo "Example: prioritize blog_draft.md 2"
		return 1
	end
	set -l dir (dirname $argv[1])
	set -l oldname (basename $argv[1])
	set -l newname (string replace -r '^\d-' '' $oldname)
	if test "$argv[2]" != "0"
		set newname "$argv[2]-$newname"
	end
	mv "$dir/$oldname" "$dir/$newname"
end
