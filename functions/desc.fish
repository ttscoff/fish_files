# Based on comment by Adam Brenecki (https://github.com/adambrenecki) on Fish
# issue #597 (https://github.com/fish-shell/fish-shell/issues/597).

function __desc_describe -d 'Show description for function'
	set -l options "c/color"
	argparse $options -- $argv

	set -l white ''
	set -l black ''
	set -l green ''
	set -l normal ''

	if set -q _flag_color
		set white (set_color --bold white)
		set black (set_color brblack)
		set green (set_color --bold green)
		set normal (set_color normal)
	end

	set -l d (functions -Dv $argv)
	set -l description
	if test -n "$d[5]"
		set description $white""$d[5]
	else
		set description $black"No description"
	end

	printf '%s%s%s - %s%s\n' $green $argv $normal $description $normal
end

function __desc_menu -d 'Display functions using fzf with previews'
	set -l options "alias"
	argparse $options -- $argv

	if set -q _flag_alias
		desc --alias | fzf --ansi --preview='bat --color=always (type -p {1})' --preview-window=70% --query="$argv" --nth=1
	else
		desc --all | fzf --ansi --preview='bat --color=always (type -p {1})' --preview-window=70% --query="$argv" --nth=1
	end
end

function __desc_list_aliases -d 'List all aliases, formatted'
	set -l options "c/color"
	argparse $options -- $argv

	set -l white ''
	set -l black ''
	set -l yellow ''
	set -l normal ''

	if set -q _flag_color
		set white (set_color --bold white)
		set black (set_color brblack)
		set yellow (set_color --bold yellow)
		set normal (set_color normal)
	end

	set -l aliases (alias | grep -E "^alias $argv")
	for a in $aliases
		set -l this_alias (echo "$a" | sed -E 's/^alias ([A-Za-z0-9_.]+) (.*)/\1 %% \2/')
		set -l parts (string split ' %% ' $this_alias)
		printf '%s%s%s - %s%s%s (alias)%s\n' $yellow $parts[1] $normal $white $parts[2] $black $normal
	end
end

function desc --description 'Print the description of a Fish function.'
	set -l options "h/help" "k/apropos=" "all" "a/alias" "nocolor" "m/menu"

	argparse $options -- $argv

	function print_help
		desc desc
		echo "NAME"
		echo
		echo "     desc - List function descriptions"
		echo
		echo "SYNOPSIS"
		echo
		echo "     desc [options] [FUNCTION]"
		echo
		echo "DESCRIPTION"
		echo
		echo "     Run with no arguments to list all functions. Include a single argument to display just that function/alias."
		echo
		echo "COMMAND OPTIONS"
		echo "     -k, --apropos=QUERY  - Search functions and aliases for "
		echo "     -a, --alias          - Search aliases only"
		echo "     --nocolor            - Don't colorize output"
		echo "     --all                - List all functions (default if run without arguments)"
		echo "     --menu               - Preview functions in menu (requires fzf)"
	end

	if set -q _flag_help
		print_help
		return 0
	end

	if set -q _flag_menu
		if set -q _flag_alias
			__desc_menu --alias $argv
		else
			__desc_menu $argv
		end
		return 0
	end

	if set -q _flag_apropos
		if set -q _flag_alias
			if set -q _flag_nocolor
				desc --nocolor --all --alias | grep --color=never -i "$_flag_apropos" | less -XFr
			else
				desc --all --alias | grep -i "$_flag_apropos" | less -XFr
			end
		else
			if set -q _flag_nocolor
				desc --nocolor --all | grep --color=never -i "$_flag_apropos" | less -XFr
			else
				desc --all | grep -i "$_flag_apropos" | less -XFr
			end
		end
		return 0
	end

	if set -q _flag_alias
		if set -q _flag_nocolor
			__desc_list_aliases | less -XFr
		else
			__desc_list_aliases --color | less -XFr
		end
		return 0
	end

	# Do we want to print *all* descriptions?
	if set -q _flag_all
		set -l descriptions
		for f in (functions | sed -E 's/(.*), /\1\n/g')
			if set -q _flag_nocolor
				set -a descriptions (desc --nocolor $f)
			else
				set -a descriptions (desc $f)
			end
		end
		printf '%s\n' $descriptions | less -XFr

		return 0
	else
		if test (count $argv) -eq 0
			if set -q _flag_nocolor
				desc --nocolor --all
			else
				desc --all
			end
			return 1
		end

		# Check that $argv is indeed a Fish function
		if not functions -q $argv
			if set -q _flag_nocolor
				printf '%s - not a function\n' $argv
			else
				printf '%s%s%s - %snot a function\n' (set_color --bold red) $argv (set_color normal) (set_color --bold white)
			end
			return 1
		end

		# # Check that the function has a description
		# if not functions $argv | grep -q -e 'function '$argv' .*--description'
		# 	printf 'The function "%s" has no description.\n' $argv
		# 	return 2
		# end

		# Print description
		if set -q _flag_nocolor
			__desc_describe $argv
		else
			__desc_describe --color $argv
		end
	end
end
