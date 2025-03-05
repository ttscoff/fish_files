function dit --wraps='docker run -it' --wraps=docker --description 'alias dit docker run -it'
  docker run -it $argv; 
end
