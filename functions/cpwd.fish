# Defined in - @ line 1
function cpwd --description alias\ cpwd=pwd\|tr\ -d\ \"\\n\"\|pbcopy
	pwd|tr -d "\n"|pbcopy $argv;
end
