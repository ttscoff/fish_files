# Defined in /var/folders/q7/sps8n5_534q22bx1ts4xjjl00000gn/T//fish.8jQ09r/findgist.fish @ line 2
function findgist --description 'select gist from list and display contents'
	# requires fzf (brew install fzf) and gist (brew install gist)
	gist -r (gist -l | awk -F/ '{print $NF}' | fzf -1 -0 --layout="reverse" -q "$argv" | awk '{ print $1 }')
end
