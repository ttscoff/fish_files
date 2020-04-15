function md -d 'Test if current directory is bookmarked'
	set_color brgreen && marks | grep --color=never (realpath .) | awk '{print $1}'
	set_color normal
end
