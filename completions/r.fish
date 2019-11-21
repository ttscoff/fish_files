function __fish_rake_tasks
	rake -T 2>/dev/null | cut -d" " -f2- | sed -E 's/ +/ /g' | sed -E 's/\[.+\]//' | awk -F" # " '{ printf $1"\t"$2"\n"; }'
end

complete -xc r -c rake -a '(__fish_rake_tasks)'
