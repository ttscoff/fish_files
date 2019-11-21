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

# na
set -x NA_TODO_EXT "taskpaper"
set -x NA_NEXT_TAG "@na"
set -x NA_DONE_TAG "@done"
set -x NA_MAX_DEPTH 2
set -x NA_AUTO_LIST_FOR_DIR 1
set -x NA_AUTO_LIST_IS_RECURSIVE 0

unset PYTHONPATH
source ~/.config/fish/custom/custom.fish
rvm default

source ~/.iterm2_shell_integration.fish
thefuck --alias | source
set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths
