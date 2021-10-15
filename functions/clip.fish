function clip --description 'Copy file to clipboard'
    set -l concat
	for f in $argv
        is text "$f" 2> /dev/null
        if test $status -eq 0
            set concat $concat $f
            echo "Adding $f to clipboard."
        else
            echo "File \"$f\" is not plain text."
        end
    end

    if [ "$concat" != "" ]
        command cat $concat | pbcopy
        echo "Copied"
    end
end

