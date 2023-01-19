function dockcomm -d 'commit a docker image'
	set -l img (docker ps -a|grep $argv[1]|awk '{print $1}'|head -n 1)
	if test -z "$img"
		warn -e "Image $argv[1] not found"
	else
		docker commit $img $argv[1]
	end
end
