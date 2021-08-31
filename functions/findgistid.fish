# Defined in /var/folders/q7/sps8n5_534q22bx1ts4xjjl00000gn/T//fish.o3Ldio/findgistid.fish @ line 2
function findgistid --description 'select gist from list and display contents'
  # requires fzf (brew install fzf) and gist (brew install gist)
  gist -l | awk -F/ '{print $NF}' | fzf --layout="reverse" -q "$argv" | awk '{ print $1 }'
end
