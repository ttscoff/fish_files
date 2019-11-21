function cpwd -d 'Copy the current directory path to the clipboard'
	pwd | tr -d "\n" | pbcopy $argv

end
