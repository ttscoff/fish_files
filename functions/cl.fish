function cl -d 'copy output of last command to clipboard'
	set -l last (history --max=1|sed -e 's/^ +//')
	eval $last | pbcopy
end
