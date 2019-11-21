function describe -d 'Show description for function'
	set -l d (functions -Dv $argv)
	echo (set_color --dim brblue)"$d[1]:$d[3] ($d[2])"(set_color normal)
	echo (set_color --bold white)"> $d[5]"(set_color normal)
end
