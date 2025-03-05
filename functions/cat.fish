function cat -d "Use bat instead of cat unless it's a Markdown file, then use mdless"
	set -l exts md markdown txt taskpaper

	if not test -f $argv[-1]
		echo "File not found: "$argv[-1]
		return 0
	end

	if contains (get_ext $argv[-1]) $exts
		mdless $argv
	else
		command bat --style plain --theme OneHalfDark $argv
	end
end
