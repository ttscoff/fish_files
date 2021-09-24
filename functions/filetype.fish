function filetype -d 'Returns the kMDItemContentTypeTree for a file'
	for file in $argv
		set -l filetype (mdls -raw -name kMDItemKind "$file")
		box (set_color brwhite)"$file: "(set_color yellow)"$filetype"
		echo (set_color brwhite)(mdls -raw -name kMDItemKind "$file")(set_color normal)
		mdls -raw -name kMDItemContentTypeTree "$file" | sed '1d;$d' | sed -E 's/^ *"(.*)",?/\1/g'
	end
end
