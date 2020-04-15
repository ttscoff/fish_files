function md -d 'Test if current directory is bookmarked'
	marks | grep --color=never (pwd) | colout '(\w+)\s+(->)\s+(.*)' green,blue,white
end
