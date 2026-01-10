function last-function-name --argument index --description 'Return the last function name from command history'
    if test -z "$index"
        set index 1
    end
    set function_name (history --prefix func | grep -w -E '^(functions?|func(ed|subl))' | string replace -- ' -s ' ' ' | awk 'NF>1' | row $index | coln 2)

    if test -n "$function_name"
        echo $function_name
    else
        echo "No function name found for index $index"
    end
end
