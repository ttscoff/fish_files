function gaa --wraps='git add (git top)' --wraps='git add' --description 'alias gaa git add (git top)'
  git add (git top) $argv; 
end
