# lsfuncs.fish: prints a dynamic list of user-installed Fish functions (and lists a user's brews and scripts found in ~/.config/bin)
#
# author @100ideas - github.com/100ideas
# latest revision Dec 2, 2021
# License: MIT
#
# published: 16 mar 2022
# public repo: public gist: https://gist.github.com/100ideas/b27e44a5c07360917ce99cd6997e2b7b
# potential discussion: https://github.com/ttscoff/fish_files/issues/2
# original: (private dotfiles repo): https://github.com/100ideas/dotfiles/blob/master/fish/functions/lsfuncs.fis
# 
# do YOU have a growing list of fish shell scripts, functions, and miscellaneous other polyglot executables in your home
# directory? Do you sometomes forget what you named one of your recent (or ancient) scripts?
#
# this is a fish function that tries to list as many of these as it can find in a nice text table to you terminal.
#
#   1) lists all user-defined functions in a tabular list in terminal. 
#      it displays descriptions if available.
#
#   2) similarly, iterates through local ~/.config/bin directory and lists info about executables it finds there.
#      I keep this dir in version control and just toss utility scripts and programs into...
#
#   3) Lastly, it generates & caches a plaintext log of all homebrew leaf 'brews' that have been installed 
#      (they don't depend on other brews so are likely to be main packages). Also does a list of kegs. Takes a while
#      to generate the list so the func waits a while (day/week) before remaking it
#
#   all this info is printed to terminal in a nice table for you to grep
#
# USAGE
#
# lsfuncs - prints "$name - #description" for each fish, brew, and misc script/binary 
#           found around users'$HOME (brew list is cached). Presumably each result is on users $PATH.
#
# EXAMPLE
#
#     ~/dev❯ lsfuncs | grep color                                                      20:57:11
#     fish_colors_monokai      - set fish color variables like monokai
#     lscolors                 - print list of fish colors
#     tree                     - Display directories as trees (with optional color/HTML output)
# 
#
# INSTALL
#
#   - depends on brew 'coreutils' because macos catalina/big bash does not have 'timeout' command
#   - adjust hardcoded search paths to your liking below
#   - put lsuncs in fish's path (~/$XDG_CONFIG_HOME/fish/functions/lsfuncs.fish)
#   
#

set my_local_bins # /usr/local/bin
# set my_local_bins fish_user_paths[1]   # instead of using fish_user_paths, just hardocde other dirs

function lsfuncs --description "Print user-defined Fish functions (including any executable files in first path of \$fish_user_paths).
	Opts:
		-a: only print fish functions;
		-p <paths>: pass additional path(s) in which to search for potential scripts, bins, commands."

	# NOT CURRENTLY USED
	# eventually would be handy to return info on single command glob if provided via fish_opt & argparse
	# i.e. `apropos` mode
	# http://fishshell.com/docs/current/commands.html#fish_opt
	set -l options (fish_opt -s a -l all) (fish_opt -s p -l paths)
	argparse $options -- $argv
	if test -n "$_flag_a"
		# use fish built-in 'functions' command to get list of *.fish user scripts stored in conventional places
		for fishfunc in (functions -a)
			# and then again to get description string set by '--description' flag in script source
			# i.e. 'function lsfuncs --description '<THIS STRING>'
			set funcdesc (functions --details -v $fishfunc | tail -n 1)
			if string match --ignore-case -e $fishfunc $funcdesc
				set_color yellow
				printf '%-24s - %.80s\n' "$fishfunc" (set_color normal) $funcdesc
			end
		end

	# logic for user-provided paths via '-p' param
	else if test -n "$_flag_p"
		# only append user-provided paths if they exist
		for p in $argv
			if test -e $p
				set my_local_bins $my_local_bins $p
			end
		end
	# else if
	#  TBD

	else

		printf "\n############\n $options\n $_flag_a \n $_flag_p \n my_local_bins:\n$my_local_bins\n#############"

		############################################################################
		# look for user-defined fish functions
		set_color brblue
		printf "\n$fish_function_path[1]:\n"
		for fishfunc in (ls $fish_function_path[1]/*.fish | sed -E "s#.*fish\/functions\/(.*)\.fish#\1#")
			set_color yellow
			printf '%-24s - %.80s\n' "$fishfunc" (set_color normal; functions --details -v $fishfunc | tail -n 1)
		end

		############################################################################
		# look my other shell scripts
		#
		# I keep general-purpose scripts & tools in ~/.config/bin (symlinked to ~/dev/bin;
		# with all of ~/.config kept in version control). This path is always the first entry in my $fish_user_paths or bash $PATH
		set_color brblue
		set -g userfunc # needed global scope so other func can get at tit
		for userpath in $my_local_bins
			printf "\n$userpath\n"
			# loop through all paths that are executable and are not directories
			for userfunc in (find $userpath\/* -d 0 -perm +755 -not -type d)
				# is it a script or is it a binary?
				set is_text (file -Ib $userfunc | grep '^.*text\/')
				set_color yellow
				if test -n "$is_text"  # it's a script
					printf '%-24s - %.80s\n' (echo $userfunc | sed -E "s#.*bin\/(.*)#\1#") \
						# print first comment line (assumes comments start with with '#')
						(set_color normal; sed -E '/^#!/d; s/^\s*# (.*)$/\1/p; s/_*description[_ =]*//p; d' $userfunc | head -n 1)
					set is_text false
				else # it's binary
					# does a man page exist for the command? (asking man to return path to man page else return status 127)
					if command man -w (basename $userfunc) > /dev/null 2>&1
						# get description by parsing man page DESCRIPTION first line
						printf '%-24s - %.80s\n' (echo $userfunc | sed -E "s#.*bin\/(.*)#\1#") \
						(set_color normal; command man (basename $userfunc) | col -bx | grep -A 1 DESCRIPTION | tail -n 1 | string trim --left)
					else
						tryToGetHelpString  ## TODO THIS FUNC IS NOT GETTING CALLED (for 'lc' binary in dev/bin for instance)
					end
				end
			end
		end

		############################################################################
		# cache, parse and print homebrew descriptions (only installed LEAF formulas)
		#   see ~/.config/bin/brew-lsbrews
		set_color brblue
		# set stale
		set -l homebrew_bin (brew --prefix)"/bin/"
		set -l cache "$XDG_CONFIG_HOME/bin/brew-lsbrews.cache"
		set -l lsbrew "$XDG_CONFIG_HOME/bin/brew-lsbrews"
		set -l stale true
		set -l lsbrews_age (stat -f "%m" $cache)
		set -l homebrews_age (stat -f "%m" $homebrew_bin)
		set -l last_update (stat -f "%Sm" $cache)
		set -l OLDLINES (wc -l $cache | cut -c 1-9)
		# has homebrew has been updated OR is the cache file empty? regeneratate....

		# echo "$lsbrews_age -gt $homebrews_age: "
		# if test $lsbrews_age -gt $homebrews_age
		#   echo lsbrews yes
		# end
		# echo "(wc -l $cache | cut -c 1-9): $OLDLINES"
		# if test $OLDLINES -lt 2
		#   echo $OLDLINES yes
		# end

		if test $lsbrews_age -gt $homebrews_age -a $OLDLINES -gt 2
			set stale false
			printf '\n%-24s - %.80s\n' $homebrew_bin "lsbrew.cache last updated $last_update"
		else
			set stale true
			printf '\n%-24s - %.80s\n\n' $homebrew_bin "lsbrew.cache last updated $last_update "(set_color -u -o brred)"[STALE]"(set_color brblue)
			set_color normal; set_color brblack
			brew-lsbrews &
			wait
		end
		# https://fishshell.com/docs/current/cmds/read.html?highlight=read#example
		cat $cache | while read -l name desc
			set_color yellow
			printf '%-24s - %.80s\n' $name (set_color normal && echo $desc)
		end
	end
end

function tryToGetHelpString
	set valid_help_param false
	set help_text "" # zero-length string, if set to something test -n below is true

	# printf "\n\ntrying $userfunc --help\n\n"

	if timeout 1 sh -c "$userfunc --help" > /dev/null 2>&1
		set valid_help_param "--help"
	else if timeout 1 sh -c "$userfunc -h" > /dev/null 2>&1
		set valid_help_param "-h"
	end

	echo "#### valid_help_param: $valid_help_param ####"

	if test -n $valid_help_param
		set help_text (timeout 1 sh -c "$userfunc $valid_help_param" | awk 'length($0) > 30' | head -n 1 | string trim --left)
	else
		set basecmd = (basename $userfunc)
		# set help_text (timeout 1 sh -c "$userfunc" 2>&1)
		# set help_text (cat $help_text | awk 'length($0) > 30' | head -n 1 | string trim --left)
		# printf '%-24s - %.80s\n' (echo "got exec_output: $exec_output")
		if tldr $basecmd | grep -A 2 $basecmd | head -n 3 | tail -n 2 | grep $basecmd
			set help_text (tldr $basecmd | grep -A 2 $basecmd | head -n 3 | tail -n 2)
		else if test (__fish_apropos $basecmd | grep -E "^$basecmd\(.*")
			set help_text (apropos $basecmd | grep -E "^$basecmd\(.*")
			set help_text (string split --right --max 1 ' - ' $help_text | tail -n 1)
		else
			set help_text "??? unsure"
		end
	end
	printf '%-24s - %.80s\n' (echo basename $userfunc | sed -E "s#.*bin\/(.*)#\1#") \
		(set_color normal; printf '%-24s - %.80s\n' $help_text)
end



#   # try to exec binary with '-h' help flag then return first line
#     printf '%-24s - %.80s\n' (echo $userfunc | sed -E "s#.*bin\/(.*)#\1#") \
#     (set_color normal; sh -c "$userfunc -h" | awk 'length($0) > 30' | head -n 1 | string trim --left)
#   else if sh -c "$userfunc --help" > /dev/null 2>&1
#     printf '%-24s - %.80s\n' (echo $userfunc | sed -E "s#.*bin\/(.*)#\1#") \
#     (set_color normal; sh -c "$userfunc --help" | awk 'length($0) > 30' | head -n 1 | string trim --left)
#   else
#     printf '%-24s - %.80s\n' (echo $userfunc | sed -E "s#.*bin\/(.*)#\1#") \ (set_color normal; echo "????")
#   end
# end

set -eg userfunc
