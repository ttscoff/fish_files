complete -xc o -a (basename -s .app /Applications{,/Setapp}/*.app|awk '{printf "\"%s\" ", $0 }')
