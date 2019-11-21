#!/bin/bash
# In my tag-filing system where top-level "context" folders are tagged with
# "=Context" tags and subfolders are tagged with "@project" tags, this function
# lets me quickly cd to any tagged folder in my filing system. The first
# argument is a context folder, the rest are a chain of subfolders. The
# subfolders don't need to be contiguous, and the matching is fuzzy.
cdt() {
	local fuzzy root sub list terms shortest

	if [[ $# == 0 || $1 =~ ^\-?\-h(elp)?$ ]]; then
		\cat <<-EOS
			$FUNCNAME changes directory based on tagged folders
			A + preceding the first search term locates a =Context folder
			usage: $FUNCNAME search terms
		EOS
		return
	fi

	root=~

	# terms can be separated by spaces or concatenated with colons (or mixed)
	OLDIFS=$IFS
	IFS=:
	terms=(`echo "$*" | sed -E 's/:/ /g' | sed -E 's/ +/:/g' | tr -d ' '`)

	IFS=$OLDIFS
	# if the first arg starts with +, it's a context
	if [[ ${terms[0]} =~ ^\+ ]]; then
		fuzzy=`echo ${terms[0]##[\+]} | sed 's/\([[:alpha:]]\)/\1*/g' | tr -d ' '`
		# term must match first letter
		root=`mdfind -onlyin ~ "kMDItemUserTags = '=$fuzzy'c && kMDItemContentType = 'public.folder'"|head -n 1`
		unset terms[0]
	fi

	for term in "${terms[@]}"; do
		fuzzy=`echo ${term//[:\.]/} | sed 's/\([[:alpha:]]\)/\1*/g'`

		# if the term starts with a dot, treat it as a directory name only search
		if [[ $term =~ ^\. ]]; then
			OLDIFS=$IFS; IFS=$'\n'
			list=(`find ${root// /\\ } -maxdepth 3 -type d -iname "*${term//[:\.]/}*"`)

			IFS=$OLDIFS

			# Use the shortest match
			shortest=${list[0]}
			if [[ ${#list} > 1 ]]; then
				shortest=${list[0]}
				for found in $list; do
					if test ${#found} -lt ${#shortest}; then
						shortest=$found
					fi
				done
			else
				shortest=${list[0]}
			fi

			[[ -d "$shortest" ]] && sub=$shortest
			# sub=`find ${root// /\\ } -maxdepth 3 -type d -iname "${term//[:\.]/}"|head -n 1`
		else
		# default: search for @tagged folders in ~ or =Context
			sub=`mdfind -onlyin ${root// /\\ } "kMDItemUserTags = '@$fuzzy'c && kMDItemContentType = 'public.folder'"`
		fi

		if [[ -n $sub ]]; then
			root=$sub
		else
			# otherwise, search for a folder with a matching name
			# list=(`mdfind -onlyin ${root// /\\ } "kMDItemDisplayName = '$fuzzy'c && kMDItemContentType != 'com.apple.package' && kMDItemContentType = 'public.folder'"`)
			OLDIFS=$IFS; IFS=$'\n'
			list=(`find "$root" -maxdepth 3 -type d -iname "$fuzzy"`)
			IFS=$OLDIFS

			# Use the shortest match
			shortest=${list[0]}
			if [[ ${#list} > 1 ]]; then
				shortest=${list[0]}
				for found in $list; do
					if test ${#found} -lt ${#shortest}; then
						shortest=$found
					fi
				done
			else
				shortest=${list[0]}
			fi

			[[ -d "$shortest" ]] && root=$shortest
		fi
	done

	if [[ -d $root && $root != "~" ]]; then
		echo $root
	fi
}

cdt $@
