## requires: funced
function funcsubl --wraps=funced\ -e\ \'subl\ -w\'\ -s --wraps=funced --description 'Edit a function with Sublime Text (autosaves)'
    funced -e 'code -w' -s $argv
end
