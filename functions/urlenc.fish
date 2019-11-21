# Defined in /Users/ttscoff/.config/fish/brett.fish @ line 210
function urlenc --description 'url encode the passed string'
	if test (count $argv) > 0
    echo -n "$argv" | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
  else
    command cat | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
  end
end
