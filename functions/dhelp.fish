function dhelp --wraps='open "dash://fish:"(urlenc $argv)' --wraps=help --description 'alias dhelp open "dash://fish:"(urlenc $argv)'
  open "dash://fish%3A"(urlenc $argv)
end
