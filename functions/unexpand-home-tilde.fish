function unexpand-home-tilde -d 'Change $HOME to ~'
    command cat | string replace $HOME '~'
end
