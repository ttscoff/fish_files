# Defined in /var/folders/q7/sps8n5_534q22bx1ts4xjjl00000gn/T//fish.2ECNLK/clip.fish @ line 2
function clip --description 'Copy file to clipboard'
	set -l ftype (file "$argv"|grep -c 'text')
    if test $ftype -eq 1
        command cat "$argv" | pbcopy
        echo "Contents of $argv are in the clipboard."
    else
        echo "File \"$argv\" is not plain text."
    end
end
