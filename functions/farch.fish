function farch -d "Test Architecture of Framework"
	set -l fname (basename $argv)
	set -l fpath $fname/Versions/Current/(basename $fname .framework)
	echo "$fpath"
	lipo -archs "$fpath"
end
