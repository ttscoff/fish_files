function browser -d "Write output to a temp HTML file and open in default browser"
	set -l f /tmp/browser.(random).html
	cat /dev/stdin >$f
	open $f
end
