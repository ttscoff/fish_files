function browser
	set -l f /tmp/browser.(random).html
	cat /dev/stdin >$f
	open $f
end
