# Defined in /Users/ttscoff/.config/fish/brett.fish @ line 136
function 64font --description 'encode a given font file as base64 and output css background property to clipboard'
	openssl base64 -in "$argv" | awk -v ext=(get_ext $argv) '{ str1=str1 $0 }END{ print "src:url(\"data:font/"ext";base64,"str1"\")  format(\""ext"\");" }'|pbcopy
  echo "$argv encoded as font and copied to clipboard"
end
