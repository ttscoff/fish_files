# Defined in /Users/ttscoff/.config/fish/brett.fish @ line 131
function 64enc --description 'encode a given image file as base64 and output css background property to clipboard'
	openssl base64 -in "$argv" | awk -v ext=(get_ext $argv) '{ str1=str1 $0 }END{ print "background:url(data:image/"ext";base64,"str1");" }'|pbcopy
  echo "$argv encoded to clipboard"
end
