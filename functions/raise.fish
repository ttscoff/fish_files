function raise -d 'Like ruby raise, but for fish'
	set -l code 1
	set -l msg
	if test (count $argv) -gt 1
		set code $argv[-1]
		set --erase argv[-1]
	end
	warn --error "$argv"
	return $code
end
