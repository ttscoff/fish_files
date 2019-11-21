function cat -d "Use bat instead of cat unless it's a Markdown file, then use mdless"
	set -l exts md markdown txt
	if contains (get_ext $argv) $exts
		mdless $argv
	else
		command bat --style plain --theme OneHalfDark $argv
	end
end
