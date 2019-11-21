function esc -d 'Ruby cgi unescape'
	set -l options "c/copy"
	set -l copy 0
	set -l output ""

	argparse $options -- $argv

	if set -q _flag_copy
		set copy 1
	end

	if test (count $argv) -eq 0
		if test "$copy" -eq 1
			cat | ruby -rcgi -e 'print CGI.unescape(STDIN.read.strip).rstrip' | pbcopy
			echo "Result in clipboard"
		else
			cat | ruby -rcgi -e 'print CGI.unescape(STDIN.read.strip).rstrip'
		end
	else
		if test "$copy" -eq 1
			ruby -rcgi -e 'print CGI.unescape(ARGV.join(" ")).rstrip' $argv | pbcopy
			echo "Result in clipboard"
		else
			ruby -rcgi -e 'print CGI.unescape(ARGV.join(" ")).rstrip' $argv
		end
	end
end
