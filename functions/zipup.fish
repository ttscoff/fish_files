function zipup -d 'exports a clean copy of the current git repo (master) to a zip file'
	if test (count $argv) -ne 1
		echo "Usage: zipup DESTINATION.zip"
		return 1
	end
	git archive --format zip --output $argv master
end
