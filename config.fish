set -x R_VERIFY_TASK false
set -x R_AUTO_TIMEOUT 5
set -x R_DEBUG false
set -x R_QUIET false
set -x GOPATH ~/gocode

# Set my editor and git editor
# set -x EDITOR "/usr/local/bin/subl -w"
# set -x GIT_EDITOR '/usr/local/bin/subl -w'
set -x EDITOR "$HOME/scripts/editor.sh"
set -x GIT_EDITOR "$HOME/scripts/editor.sh"
set -x EDITSCRIPT_EDITOR "$HOME/scripts/editor.sh"
set -x EDITSCRIPT_PATH "~/scripts:~/scripts/fish:~/.config/fish:~/.config/fish/functions:~/bin:~/.bash_it/custom:~/.bash_it/**/enabled:~/.*"
set -x EDITSCRIPT_TYPES "rb,sh,py,bash,fish,,"

# Reiki Config
set -xg R_VERIFY_TASK false
set -xg R_AUTO_TIMEOUT 5
set -xg R_DEBUG false
set -xg R_QUIET false
# Editscript (eds) config
set -xg EDITSCRIPT_EDITOR "$HOME/scripts/editor.sh"
set -xg EDITSCRIPT_PATH "~/scripts:~/scripts/fish:~/.config/fish:~/.config/fish/functions:~/bin:~/.bash_it/custom:~/.bash_it/**/enabled"
set -xg EDITSCRIPT_TYPES "rb,sh,py,bash,fish,,"
# na
set -x NA_TODO_EXT "taskpaper"
set -x NA_NEXT_TAG "@na"
set -x NA_DONE_TAG "@done"
set -x NA_MAX_DEPTH 2
set -x NA_AUTO_LIST_FOR_DIR 1
set -x NA_AUTO_LIST_IS_RECURSIVE 0
# quickquestion
set -xg QQ_NOTES_DIR "/Users/ttscoff/Library/Mobile Documents/9CR7T2DMDG~com~ngocluu~onewriter/Documents/nvALT2.2"
set -xg QQ_NOTES_EXT "md"
set -xg QQ_NOTES_PRE "??"
set -xg QQ_EDITOR "vim"
# dontforget
set -xg DF_LAUNCHBAR true
set -xg DF_SPEAK false

unset PYTHONPATH
source ~/.config/fish/custom.fish
rvm default

source ~/.iterm2_shell_integration.fish
thefuck --alias | source
set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths

if status is-interactive && functions -q git_fzf_key_bindings
	git_fzf_key_bindings
end
