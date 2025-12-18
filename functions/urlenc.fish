
function urlenc --description 'url encode the passed string'
    if test (count $argv) -gt 0
        echo -n "$argv" | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
    else
        set input ""
        while read -l line
            set input "$input$line\n"
        end
        # Remove the trailing newline
        set input (string trim -r -- "$input")
        echo -n "$input" | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
    end
end
