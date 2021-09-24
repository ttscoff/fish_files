function fasdfzf -d 'Helper function to return a file via fasd and fzf'
	set -l options "f/file" "d/directory"
	argparse $options -- $argv
	set -l args 'lR'
	if set -q _flag_f
		set args 'f'$args
	else if set -q _flag_d
		set args 'd'$args
	else
		set args 'a'$args
	end

	set -l tgt (fasd -$args $argv | fzf -1 -0)
	if [ (echo $tgt) ]
		echo "$tgt"
	end
end
