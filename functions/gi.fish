function gi --description 'gitignore.io cli for fish'
	if test "$argv[1]" = 'update-completions'
		__gi_update_completions
		return $status
	end

	set -l params (echo $argv|tr ' ' ',')
	curl -L -s https://www.gitignore.io/api/$params
end
