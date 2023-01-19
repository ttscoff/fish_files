function dman -d 'Open man page in Dash'
	open "dash://man%3A"(urlenc $argv)
end
