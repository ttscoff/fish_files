function uncolor -d "Remove color codes from string"
	cat | sed -E 's/[^[:print:]]//g; s/\[([0-9]{1,3}(;[0-9]{1,3})?)?m//g'
end
