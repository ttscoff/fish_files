# Defined in /Users/ttscoff/.config/fish/functions/showalias.fish
function showalias --description 'Show an alias'
	set val (alias | grep -e "^alias $argv " | sed -e "s/alias $argv //")
	echo "$argv = $val"
end
