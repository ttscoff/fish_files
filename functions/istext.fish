function istext -d 'test if given file is plain text'
	if test (file $argv |grep -c text) -ne 0
		return 0
	else
		return 1
	end
end
