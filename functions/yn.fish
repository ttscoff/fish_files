function yn --description 'Simple pass/fail test for given command'
	eval $argv && yep || nope
end
