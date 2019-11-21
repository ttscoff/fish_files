function lsz -d 'ls for inside of compressed archives'
	set -l pager (__best_pager)
	if test (count $argv) -ne 1
		echo "lsz filename.[tar,tgz,gz,zip,etc]"
		return 1
	end
	if test -f $argv
		switch $argv
			case '*.tar.bz2' '*.tar.gz' '*.tar' '*.tbz2' '*.tgz'
				tar tvf $argv | $pager
			case '*.zip'
				unzip -l $argv | grep -v __MACOSX | $pager
			case '*'
				echo "'$argv' unrecognized."
		end
	else
		echo "'$argv' is not a valid file"
	end
end
