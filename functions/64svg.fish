function 64svg --description 'encode a given svg file as base64 and output css background-image property to clipboard'
	openssl base64 -in "$argv" | awk -v ext='svg+xml' '{ str1=str1 $0 }END{ print "background-image: url(""data:image/"ext";base64,"str1""");" }' | pbcopy
	echo "$argv encoded to clipboard"
end
