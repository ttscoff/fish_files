# Defined in /var/folders/q7/sps8n5_534q22bx1ts4xjjl00000gn/T//fish.aHGmLU/gitar.fish @ line 1
function gitar
	git ls-files -d -m -o -z --exclude-standard | xargs -0 git update-index --add --remove
end
