# biras_weird_cousin
# Theme based on Bira theme from oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/bira.zsh-theme
# Some code stolen from oh-my-fish clearance theme: https://github.com/bpinto/oh-my-fish/blob/master/themes/clearance/

# Adds a badge if we're in an SSH session (first letter of hostname, uppercased)
function __ssh_badge
	if test -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY"
		set_color -b d6aeec -o 2a0a8b
		echo -n " "(string upper (string sub -s 1 -l 1 (hostname -s)))" "
		set_color normal
	end
end

# only display a host name if we're in an ssh session
function __ssh_host
	if test -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY"
		set_color -d white
		echo -n $USER@
		set_color normal
		set_color -d -o brmagenta
		echo -n (hostname -s)
		set_color normal
	end
end

function __user_host
	if test (id -u) -eq 0
		set_color --bold red
	else
		set_color --bold green
	end
	echo -n $USER@(hostname -s) (set_color normal)
end

function __current_path
	# Replace HOME with ~ (or 🏠)
	set -l path (string replace "$HOME" (set_color brmagenta)"~"(set_color ccc) (pwd))

	# see if we're in a git project, highlight in path
	set repo (git rev-parse --show-toplevel 2>/dev/null)
	if not test "$repo" = ""
		set repo (string replace "$HOME" "" $repo)
		set path (string replace "$repo" (set_color yellow)"$repo"(set_color ccc) $path)
	end

	# Highlight last path element
# set -l parts (string split "/" $path)
# set parts[-1] (set_color normal)(set_color brwhite)$parts[-1](set_color normal)
# set path (string join "/" $parts)

	echo -n " "$path(set_color normal)
end

function _git_branch_name
	echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
	echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function __git_status
	if [ (_git_branch_name) ]
		set -l git_branch (_git_branch_name)

		if [ (_git_is_dirty) ]
			set git_color "yellow"
			set git_info '('$git_branch"*"')'
		else
			set git_color "green"
			set git_info '('$git_branch')'
		end

		echo -n (set_color $git_color) $git_info (set_color normal)
	end
end

function __ruby_version
	# Show versions only for Ruby-specific folders
	if not test -f Gemfile \
		-o -f Rakefile \
		-o (count *.rb) -gt 0
		return
	end

	set -l __rvm_default_ruby (grep GEM_HOME $rvm_path/environments/default 2>/dev/null | sed -e"s/'//g" | sed -e's/.*\///')
	set -l __rvm_current_ruby_i (rvm-prompt i)
	set -l __rvm_current_ruby_v (rvm-prompt v g)
	set -l __rvm_current_ruby

	# Add * if default
	if test "$__rvm_default_ruby" = "$__rvm_current_ruby_i-$__rvm_current_ruby_v"
		set __rvm_current_ruby_v "*$__rvm_current_ruby_v"
	end
	# Only show interpreter if it's not 'ruby'
	if not test "$__rvm_current_ruby_i" = "ruby"
	   set __rvm_current_ruby "$__rvm_current_ruby_i-$__rvm_current_ruby_v"
	else
		set __rvm_current_ruby "$__rvm_current_ruby_v"
	end
	echo -n (set_color red) "<$__rvm_current_ruby>"(set_color normal)
end

function fish_prompt -d '"Bira\'s weird cousin" prompt'
	set -l st $status
	set -l pchar (set_color --bold white)"❯"
	if [ $st != 0 ];
		set pchar (set_color --bold red)"❯"
	end

	echo -n (set_color green)"┌"(set_color normal)
	#__user_host
	__ssh_badge
	__current_path
	__ruby_version
	__git_status
	echo -e ''

	## SetMark adds iTerm marks, but now it's being set with an event hook
	## via shell integration
	# echo -e "\033]1337;SetMark\a"
	echo -e (set_color green)"└─$pchar "(set_color normal)
end

function fish_right_prompt
	set -l st $status
	if [ $st != 0 ];
		echo (set_color red) ↵ $st (set_color normal)
	end
	__ssh_host
	if test "$CMD_DURATION" -gt 3000
		set_color -o 888
		set -l duration (echo -n $CMD_DURATION | __human_time)
		printf ' (%s)' $duration
	end
	set_color -o 666
	date '+ %T'
	set_color normal
end
