function __ls_text_files -d "List all text files in current directory"
	set -l text_files
	for file in *
		if __is_text "$file"
			set -a text_files $file
		end
	end
	printf '%s\n' $text_files
end
