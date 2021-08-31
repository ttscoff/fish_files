function __should_na --on-variable PWD
	# function __should_na --on-event fish_prompt
	test -s (basename $PWD)".taskpaper" && ~/scripts/fish/na
end
