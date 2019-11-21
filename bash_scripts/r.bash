#!/bin/bash
#!/bin/bash
#             __ __    __
# .----.-----|__|  |--|__|
# |   _|  -__|  |    <|  | Reiki
# |__| |_____|__|__|__|__| by Brett Terpstra 2015
#
# MIT License
#
# Reiki, called with `r`, is a shortcut for running a single rake task with arguments.
# No brackets, just spaces and commas, and colons to separate serial tasks if needed.
#
# $ r bld xcode true: launch debug
# => rake build[xcode,true] launch[debug]
#
# Use r -H
# See <http://brettterpstra.com/projects/reiki/> for more information.
#
# Configure the defaults:
#
# 	verify_task=1 to force a verification after guessing
# 	auto_timeout=X to change number of seconds to wait for verification, 0 to disable
# 	quiet=1 to force silent mode, using first option if multiple matches are found
# 	debug=1 for verbose reporting
#
# Defaults can be overriden by environment variables in your login profile/rc:
#
# 	export R_VERIFY_TASK=true
# 	export R_AUTO_TIMEOUT=5
# 	export R_DEBUG=true
# 	export R_QUIET=true

_r () {
	local verify_task auto_timeout quiet debug cmd

	## DEFAULTS (Environment variables override)
	verify_task=0
	auto_timeout=5
	quiet=0
	debug=0
	## END CONFIG

	[[ -n $R_VERIFY_TASK && $R_VERIFY_TASK == "true" ]] && verify_task=1
	[[ -n $R_AUTO_TIMEOUT ]] && auto_timeout=$R_AUTO_TIMEOUT
	[[ -n $R_DEBUG && $R_DEBUG == "true" ]] && debug=1
	[[ -n $R_QUIET && $R_QUIET == "true" ]] && quiet=1

	IFS='' read -r -d '' helpstring <<'ENDHELPSTRING'
r: A shortcut for running rake tasks with fuzzy matching
Parameters are %yellow%task fragments%reset% and %yellow%arguments%reset%, multiple arguments comma-separated

ENDHELPSTRING

	IFS='' read -r -d '' helpoptions <<'ENDOPTIONSHELP'

Example:
	$ %b_white%r gen dep commit message%reset%
	=> %n_cyan%rake generate_deploy["commit message"]%reset%

Options:

	%b_white%-h		%yellow%show options%reset%
	%b_white%-H		%yellow%show help%reset%
	%b_white%-a SECONDS	%yellow%Prompts run default result after SECONDS%reset%
	%b_white%-b		%yellow%Run with "bundle exec"%reset%
	%b_white%-d		%yellow%Output debug info%reset%
	%b_white%-T		%yellow%List available tasks%reset%
	%b_white%-q		%yellow%Run quietly (use first match in case of multiples)%reset%
	%b_white%-v		%yellow%Interactively verify task matches before running%reset%
ENDOPTIONSHELP

	local options="" bundle=""
	OPTIND=1
	while getopts "bqvdTa:hH" opt; do
		case $opt in
			T) rake -T; return;;
			b) bundle="bundle exec " ;;
			h) __color_out "$helpoptions"; return;;
			H)
				__color_out "$helpstring";
				__color_out "$helpoptions";
				return;;
			q)
				options+=" -q"
				quiet=1; verify_task=0 ;;
			v)
				options+=" -v"
				verify_task=1 ;;
			d) debug=1 ;;
			a)
				options+=" -a $OPTARG"
				auto_timeout=$OPTARG;;
			*)
				echo "$0: invalid flag: $1" >&2
				return 1
		esac
	done
	shift $((OPTIND-1))


	IFS=
	local s=$(echo -e $@ | sed -E 's/ *: */:/g')
	eval_this="${bundle}rake"

	IFS=$':'
	set $s
	for item; do
		eval_this+=" $(__r $verify_task $auto_timeout $quiet $debug $item)"
	done
	IFS=
	tput sgr0

	if [[ ! $eval_this =~ ^(bundle exec )?rake[[:space:]]+$ ]]; then
		eval "$eval_this"
	else
		__color_out "\n%b_red%Cancelled: %red%no command given"
	fi
}

__r () {
	# about 'shortcut for running rake tasks with fuzzy matching'
	# param 'task fragments and arguments, multiple arguments comma-separated'
	# example '$ r gen dep'
	# group 'brett'
	local verify_task=$1; shift
	local auto_timeout=$1; shift
	local quiet=$1; shift
	local debug=$1; shift
	IFS=" "
	set $@
	__r_debug $debug "Received arguments $@"

	local toplevel=$PWD

	if [ ! -f Rakefile ]; then
		toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
		if [[ -z $toplevel || ! -f $toplevel/Rakefile ]]; then
			>&2 __color_out "%red%No rakefile found\n"
			return 1
		fi
	fi

	local recent=`ls -t $toplevel/.r_completions~ $toplevel/Rakefile $toplevel/**/*.rake 2> /dev/null | head -n 1`
	if [[ ${recent##*/} != '.r_completions~' ]]; then
		ruby -rrake -e "Rake::load_rakefile('$toplevel/Rakefile'); puts Rake::Task.tasks" > .r_completions~
	fi

	local cmd args tasks closest colorout
	local timeout=""
	local arg1=$1

	if [[ $# == 0 ]]; then
		__color_out "%red%No tasks specified. Use -h for options\n"
		return
	fi

	IFS=$'\n'
	# exact match for first arg
	if [[ $(grep -cE "^$1$" $toplevel/.r_completions~) == 1 ]]; then
		__r_debug $debug "Exact match: $1"
		verify_task=0
		cmd="$1"; shift
	# exact match for first arg or first arg with underscore matching second arg
	elif [[ $(grep -cE "^$1_$2$" $toplevel/.r_completions~) == 1 ]]; then
		__r_debug $debug "Exact match for multiple params: $1_$2"
		cmd="$1_$2"; shift; shift
	# Only 1 task starts with the first arg, use it and discard additional
	# args that would match the same task
	elif [[ $(grep -cE "^$1" $toplevel/.r_completions~) == 1 ]]; then
		__r_debug $debug "Partial match: $1"
		cmd=$(grep -E "^$1" $toplevel/.r_completions~); shift
		while [[ $cmd =~ _$(__r_to_regex "$1") ]]; do shift; done
	# no exact matches, check for a fuzzy match in first argument
	elif [[ ${#1} > 1 && $(grep -cE "^$(__r_to_regex "$1")" $toplevel/.r_completions~) > 0 ]]; then
		declare -a matches=( $(grep -E "^$(__r_to_regex $1)" $toplevel/.r_completions~) )
		__r_debug $debug "Fuzzy matches: $(printf "%s, " "${matches[@]}")"
		shift
		while [[ $# > 0 && $(printf "%s\n" "${matches[@]}" | grep -cE "_$(__r_to_regex "$1")") > 0 ]]; do
			declare -a matches=( $(printf "%s\n" "${matches[@]}" | grep -E "_$(__r_to_regex "$1")") )
			shift
			__r_debug $debug "Narrowed matches: $(printf "%s, " "${matches[@]}")"
		done
		__r_debug $debug "Fuzzy match: $(printf "%s " "${matches[@]}")"
		cmd=$(__r_parse_matches $quiet $auto_timeout ${matches[@]})
		[[ -z $cmd ]] && return 1
	# multiple matches
	elif [[ $(grep -cE "^$1" $toplevel/.r_completions~) > 1 ]]; then
		declare -a matches=( $(grep -E "^$1" $toplevel/.r_completions~) )
		shift
		__r_debug $debug "Multiple matches: $(printf "%s " "${matches[@]}")"
		while [[ $# > 0 && $(printf "%s\n" "${matches[@]}" | grep -cE "_$(__r_to_regex "$1")") > 0 ]]; do
			declare -a matches=( $(printf "%s\n" "${matches[@]}" | grep -E "_$(__r_to_regex "$1")") )
			shift
		done
		cmd=$(__r_parse_matches $quiet $auto_timeout ${matches[@]})
		[[ -z $cmd ]] && return 1
	# no matches. If the first arg is more than one character,
	# try recursing with first character split out
	# elif [[ ${#1} > 1 && $(grep -cE "^${1:0:1}" $toplevel/.r_completions~) > 0 ]]; then
	# 	firstarg=$(echo "$1"|sed -E 's/([[:alnum:]])/\1 /g'); shift
	# 	__r $verify_task $auto_timeout $quiet $debug "$firstarg $@"
	# 	return
	fi

	# if we didn't find a matching task, parse for suggestions
	if [[ -z $cmd ]]; then
		declare -a matches=( $(grep -E "^$(__r_to_regex $arg1)" $toplevel/.r_completions~) )
		if [[ ${#matches[@]} == 0 ]]; then
			declare -a matches=( $(grep -E "^${arg1:0:1}" $toplevel/.r_completions~) )
		fi
		if [[ ${#matches[@]} == 0 ]]; then
			>&2 __color_out "%red%No matching task found\n"
			return 1
		fi
		>&2 __color_out "%b_white%Match not found, did you mean %b_yellow%$(printf "%%yellow%%%s%%b_white%%, " ${matches[@]}|sed -E 's/ ([^ ]+), $/ or maybe %b_yellow%\1?/'|sed -E 's/, $/%b_white%?/')\n"
		return 1
	fi

	cmd=${cmd%%[*}
	[[ $verify_task == 1 && $(__r_verify_task $cmd $auto_timeout) > 0 ]] && return 1

	colorout="%purple%$cmd" # pretty output
	if [[ "$*" != "" ]]; then
		# quote additional arguments not separated with commas
		#>	remove spaces following commas
		#>	escape parens and pipes
		#>	quote spaces between non-comma-separated args
		args=$(echo "$@"| sed -E 's/, */,/g' \
			| sed -E 's/([\(\)\|])/\\\1/g' \
			| sed -E 's/([^ ]+( +[^ ]+)+)/"\1"/')
		cmd="${cmd}[$args]"
		colorout="${colorout}%n_black%[%b_white%${args}%n_black%]" # pretty output
	fi

	[[ $quiet != 1 ]] && >&2 __color_out "%b_green%Running %n%${colorout}\n"
	[[ $debug == 1 && $quiet == 1 ]] && >&2 echo "Running $cmd"

	echo -n "$cmd"
}

# convert a string into a fuzzy regex
__r_to_regex () {
	echo -n "$*"|sed -E 's/\?/\\?/g'|sed -E 's/([[:alnum:]]) */\1.*/g'
}

# parse an array of matches
# param 1: run quietly (0,1)
# param 2: auto_timeout (0,SECONDS)
# param 3: match array
__r_parse_matches () {
	__r_debug 0 $*
	local q=$1; shift
	local a=$1; shift
	# sort matches (remaining args) by length, ascending
	IFS=$'\n' GLOBIGNORE='*' matches=($(printf '%s\n' $@ | awk '{ print length($0) " " $0; }' | sort -n | cut -d ' ' -f 2-))
	if [[ ${#matches[@]} > 1 && $q != 1 ]]; then
		verify_task=0
		local outstring="%red%${#matches[@]} matches %b_white%($(printf "%%purple%%%s%%b_white%%, " "${matches[@]}"|sed -E 's/, $//')%b_white%)\n"

		if [[ $a > 0 ]]; then
			outstring+="Assuming '%red%${matches[0]}%yellow%', running in ${a}s"
		fi
		>&2 __color_out "${outstring} ('%red%q%yellow%' to cancel)\n"
		local result cmd_match
		for match in ${matches[@]}; do
			result=$(__r_verify_task $match $a)
			if [[ $result == 1 ]]; then
				continue
			elif [[ $result == 127 ]]; then
				return 1
			else
				echo "$match"
				return 0
			fi

		done

	else
		echo "${matches[0]}"
		return 0
	fi
}

__r_debug () {
	if [[ $1 == 1 ]]; then
		shift
		>&2 echo -e "r: $*"
	fi
}

# Function to request verification of a task match
# Y, y, or enter returns 1
# any other character returns 0
__r_verify_task () {
	local timeout=""
	[[ ${2-5} > 0 ]] && timeout="-t ${2-5}"

	read $timeout -e -n 1 -ep $'\033[1;37mRun \033[31m'"$1"$'\033[37m'"? [Y/n]: "$'\033[0m' ANSWER
	case $ANSWER in
		y|Y) echo 0;;
		q|Q) echo 127;;
		[a-zA-Z0-9]) echo 1;;
		*) echo 0;;
	esac

}

# Common util for color output using templates
# Template format:
#     %colorname%: text following colored normal weight
#     %b% or %b_colorname%: bold foreground
#     %u% or %u_colorname%: underline foreground
#     %s% or %s_colorname%: bold foreground and background
#     %n% or %n_colorname%: return to normal weight
#     %reset%: reset foreground and background to default
# Color names (prefix bg to set background):
#     black
#     red
#     green
#     yellow
#     cyan
#     purple
#     blue
#     white
# @option: -n no newline
# @param 1: (Required) template string to process and output
__color_out () {
	local newline=""
	OPTIND=1
	while getopts "n" opt; do
	  case $opt in
	    n) newline="n";;
	  esac
	done
	shift $((OPTIND-1))
	# color output variables
	if which tput > /dev/null 2>&1 && [[ $(tput -T$TERM colors) -ge 8 ]]; then
		local _c_n="\033[0m"
		local _c_b="\033[1m"
		local _c_u="\033[4m"
		local _c_s="\033[7m"
		local _c_black="\033[30m"
		local _c_red="\033[31m"
		local _c_green="\033[32m"
		local _c_yellow="\033[33m"
		local _c_cyan="\033[34m"
		local _c_purple="\033[35m"
		local _c_blue="\033[36m"
		local _c_white="\033[37m"
		local _c_bgblack="\033[40m"
		local _c_bgred="\033[41m"
		local _c_bggreen="\033[42m"
		local _c_bgyellow="\033[43m"
		local _c_bgcyan="\033[44m"
		local _c_bgpurple="\033[45m"
		local _c_bgblue="\033[46m"
		local _c_bgwhite="\033[47m"
		local _c_reset="\033[0m"
	fi
	local template_str="echo -e${newline} \"$(echo -en "$@" \
		| sed -E 's/%([busn])_/${_c_\1}%/g' \
		| sed -E 's/%(bg)?(b|u|s|n|black|red|green|yellow|cyan|purple|blue|white|reset)%/${_c_\1\2}/g')$_c_reset\""

	eval "$template_str"
}

_r $@
