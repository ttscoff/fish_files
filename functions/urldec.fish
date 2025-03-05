function urldec --description 'URL decode'
    if test (count $argv) >0
        echo -n "$argv" | perl -pe'$string = s/%([A-Fa-f\d]{2})/chr hex $1/eg;print $string;'
    else
        command cat | perl -pe'$string=s/%([A-Fa-f\d]{2})/chr hex $1/eg;print $string;'
    end

end
