bind \ez __re_extension
bind \e, __prev_token
bind '?' __unfuck_previous_command
bind \eE __expand_path
# bind \er thefuck-command-line
bind --erase \cg
bind --erase \co
bind \co __fzf_open
bind \cO '__fzf_open --editor'
bind --erase \cr
# bind \cr __mcfly-history-widget
# Insert ~> and move cursor after it with Alt-=
bind \e= 'commandline -i "~> "'
