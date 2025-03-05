function line-count --description 'Count lines in a file'
    if test (count $argv) -eq 0
        echo "Usage: line-count <filename>"
        return 1
    end

    if test -e $argv[1]
        wc -l $argv[1] | string trim
    else
        echo "File not found: $argv[1]"
        return 1
    end
end
