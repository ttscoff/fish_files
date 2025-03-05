function dhelp --wraps='open "dash://fish:"(urlenc $argv)' --wraps=help --description 'Display command help in Dash'
    open "dash://fish%3A"(urlenc $argv)
    return 0
end
