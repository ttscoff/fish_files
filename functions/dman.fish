function dman -d 'Open man page in Dash'
	open "dash://man:"(urlenc $argv)
end
