function spellf -d "Get first spelling option from aspell"
    for word in $argv
        set -l results (echo -en "$word"|aspell pipe|tail -n 2|head -n 1|sed -E 's/[^:]+: //'|sed -E 's/, / /g'|sed -E 's/([[:alpha:]]+\'[[:alpha:]]*( |$)|\*)//g')
        set results (string split " " $results)
        printf '%s' $results[1]
    end
end
