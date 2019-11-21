function lno -d 'Print file with line numbers'
	if test (count $argv) -eq 1
		grep --color=never -n -E '.*' $argv[1]
	else
		echo "lno: One filename required"
		return 1
	end
end
