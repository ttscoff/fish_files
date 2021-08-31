function gemuninstall -d "Uninstall a gem with partial name matching"
	gem list | command ag "$argv" | awk '{ print $1; }' | xargs gem uninstall
end
