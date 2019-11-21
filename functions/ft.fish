function __predicate_from_args
	set -l output "kMDItemUserTags = '*"$argv[1]"*'c"
	for arg in $argv[2..-1]
		set output "$output && kMDItemUserTags = '*"$arg"*'c"
	end
	echo $output
end

function ft -d 'A shortcut for mdfinding tagged items system-wide'
	if test (count $argv) -gt 1
		and test -d $argv[1]
		set -l args (__predicate_from_args $argv[2..-1])
		mdfind -onlyin "$argv[1]" $args
	else
		set -l args (__predicate_from_args $argv)
		mdfind -onlyin ~ $args
	end

end
