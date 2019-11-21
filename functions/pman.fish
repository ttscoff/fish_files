function pman -d 'Display a man page as a PostScript PDF in Preview.app'
	man -t "$argv" | open -f -a "Preview.app"
end
