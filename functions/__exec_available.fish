function __exec_available -d 'test if command is available'
	if not type --quiet $argv
		return 1
	else
		return 0
	end
end
