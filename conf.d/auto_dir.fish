if functions -q __auto_dir
	if not functions -q __wrapped_command_not_found
		functions -c fish_command_not_found __wrapped_command_not_found
		functions -e fish_command_not_found
	end

	functions -c __auto_dir fish_command_not_found
end
