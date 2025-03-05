function setapp --wraps=echo\ \'\'\ \|\ shortcuts\ run\ \'Setapp\ Affiliate\'\ \|\ cat --description 'Get an is.gd link to a setapp affiliate page for an app (requires Setapp Affiliate shortcut)'
    echo "$argv" | shortcuts run "Setapp Affiliate" | cat
end
