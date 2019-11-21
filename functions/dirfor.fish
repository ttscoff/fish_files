function dirfor -d 'get origin directory for running process'
	ps axc | awk "/$1/"'{print  $1}' | xargs -L1 lsof -p | head -n3 | tail -n 1 | sed -E 's/ +/ /g' | cut -d' ' -f9-
end
