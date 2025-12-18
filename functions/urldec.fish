function urldec --description 'URL decode'
    if test (count $argv) -gt 0
        set output (echo -en "$argv" | perl -pe's/%([A-Fa-f\d]{2})/chr hex $1/eg')
        echo -e "$output"
    else
        set input ""
        while read -l line
            set input "$input$line\n"
        end
        # Remove the trailing newline
        set input (string trim -r -- "$input")
        set output (echo -en "$input" | perl -pe's/%([A-Fa-f\d]{2})/chr hex $1/eg')
        echo -e "$output"
    end
end
