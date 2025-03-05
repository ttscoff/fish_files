function dpl --wraps='howzit -r deploy' --description 'alias dpl=howzit -r deploy'
  howzit -r deploy $argv; 
end
