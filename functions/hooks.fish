# Requires hooked_files.rb from the bash_scripts directory
function hooks -d 'Return a list of files hooked to target (Hook.app)'
	hooked_files.rb $argv
end
