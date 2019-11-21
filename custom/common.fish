function __should_na --on-variable PWD
	test -s (basename $PWD)".taskpaper" && ~/scripts/fish/na
end
