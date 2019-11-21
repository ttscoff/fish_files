# Defined in /Users/ttscoff/.config/fish/brett.fish @ line 115
function flush --description 'Flush DNS cache'
	sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
end
