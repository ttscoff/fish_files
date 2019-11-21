function sum -d "Take a list of numbers and return the sum"
	set -l options "h/help" "c/copy"
	set -l input

	argparse -n "sum" $options -- $argv

	if set -q _flag_help
		echo "* Pass a space-separated list of numbers as arguments:"
		echo "    sum 5 15.2 3"
		echo "* Run `sum` by itself to enter numbers manually, space or newline separated,"
		echo "  end input with ^d"
		echo "* Use `sum -c` to copy result to clipboard"
		return 0
	end

	if test (count $argv) -eq 0
		read -z -a res
		set input (string join "+" $res)
		echo "-----"
	else
		set input (string join "+" (string split -n " " $argv))
	end

	set -l result (echo $input | bc -l)
	if set -q _flag_copy
		printf '%s' $result | pbcopy
		echo "Result in clipboard"
	else
		printf '%s\n' (string split "+" $input)
		echo "====="
		echo $result
	end
end
