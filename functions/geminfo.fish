function geminfo -d "Get info for a gem with partial name matching"
	gem list | command ag "$argv" | awk '{ print $1; }' | xargs gem info
end
