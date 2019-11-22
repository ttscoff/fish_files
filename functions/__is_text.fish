function __is_text -d 'Test if a file is plain text'
	set -l stats (file "$argv" )

	if string match -q "*text*" $stats
		return 0
	else
		return 1
	end
end
