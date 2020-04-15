function __all_scripts
	set -l re_home (echo $HOME|sed -e 's/\//\\\\\//g')
	for dir in $EDITSCRIPT_PATH
		echo $dir | \
			sed -e "s/~/$re_home/" | \
			xargs -I{} mdfind -onlyin "{}/" "kMDItemContentTypeTree = \"*source-code*\"c" | \
			xargs basename | sort | uniq
	end
end

complete -xc editscript -a '(__all_scripts)'
