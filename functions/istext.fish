function istext -d 'test if given file is plain text'
	# if test (file $argv |grep -ci text) -ne 0
	# 	return 0
	# else
	# 	return 1
	# end
	return (is text $argv)
end
