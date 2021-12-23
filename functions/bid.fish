function bid --description 'Get bundle id for app name'
	
	set -l shortname (echo "$argv"| sed -E 's/\.app$//'|sed 's/\\\//g')
	set -l location
	# if the file is a match in apps folder, don't spotlight
	if test -d "/Applications/$shortname.localized/$shortname.app"
		set location "/Applications/$shortname.localized/$shortname.app"
	else if test -d "/Applications/$shortname.app"
		set location "/Applications/$shortname.app"
	else # use spotlight
		set location (mdfind -onlyin /System/Applications -onlyin /Applications -onlyin /Applications/Setapp -onlyin /Applications/Utilities -onlyin ~/Applications -onlyin /Developer/Applications "kMDItemKind==Application && kMDItemDisplayName=='*$shortname*'cdw"|head -n1)
	end
	# No result? Die.
	if test -z $location
		echo "$argv not found, I quit"
		return
	end
	# Find the bundleid using spotlight metadata
	set -l bundleid (mdls -name kMDItemCFBundleIdentifier -r "$location")
	# return the result or an error message
	if test -z $bundleid
		echo "Error getting bundle ID for \"$argv\""
	else
		echo "$location: $bundleid"
	end
end
