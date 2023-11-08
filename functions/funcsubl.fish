function funcsubl --wraps=funced\ -e\ \'subl\ -w\'\ -s --wraps=funced --description 'Edit a function with Sublime Text (autosaves)'
	funced -e 'subl -w' -s $argv
end
