function unexpand-home-tilde -d 'Change $HOME to ~'
    cat | string replace $HOME '~'
end
