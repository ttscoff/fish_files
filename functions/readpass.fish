function readpass --argument var --description 'Read a password from stdin and export it as an environment variable'
    read --silent localvar
    if test -n "$localvar"
        export $var=$localvar
    else
        echo "No input provided."
    end
end
