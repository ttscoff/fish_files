function echo-variable --no-scope-shadowing --description 'Echo the value of a variable, uppercased if needed'
    if set -q -- $argv
        set varname $argv
    else
        set varname (echo $argv | string upper)
    end
    # Check if the variable name exists before echoing
    if set -q $varname
        eval 'echo $'$varname
    else
        echo "Variable '$varname' does not exist."
    end
end
