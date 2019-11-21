function er -d 'edit recent file using fasd and fzf'
	set -l target (fasd -fltR "$argv" | fzf -m --inline-info --height=5 --cycle)
	if test "$target" != ""
		istext "$target"
		if test "$status" -eq 0
			if test (string match -r '\.md$' $target)
				mmdc "$target"
			else
				subl "$target"
			end
		else
			open "$target"
		end
	end
end
