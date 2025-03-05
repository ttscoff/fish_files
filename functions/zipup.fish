function zipup -d 'exports a clean copy of the current git repo (master) to a zip file'
	if test (count $argv) -lt 1
		echo "Usage: zipup DESTINATION.zip [branch]"
		return 1
	end
	git archive --format zip --output $argv[1] (fallback $argv[2] master)
end
