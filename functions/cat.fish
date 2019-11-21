# Defined in /var/folders/q7/sps8n5_534q22bx1ts4xjjl00000gn/T//fish.QXl119/cat.fish @ line 2
function cat
	command bat --style plain --theme OneHalfDark $argv
  return
	set -l exts md markdown txt
  if contains (get_ext $argv) $exts
    mdless $argv
  else
    command bat --style plain --theme OneHalfDark $argv
  end
end
