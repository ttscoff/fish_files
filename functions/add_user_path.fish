function add_user_path -d "Shortcut to add a user path"
	set -U fish_user_paths $argv $fish_user_paths
end
