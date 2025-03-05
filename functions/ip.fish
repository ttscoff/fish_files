# Defined in /var/folders/q7/sps8n5_534q22bx1ts4xjjl00000gn/T//fish.pQ1MFc/ip.fish @ line 2
function ip --description 'Get external IP address'
	curl -Ss icanhazip.com
end
