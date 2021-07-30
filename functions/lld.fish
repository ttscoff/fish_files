# Defined via `source`
function lld --wraps='ls -ld' --description 'alias lld=ls -ld'
  ls -ld $argv; 
end
