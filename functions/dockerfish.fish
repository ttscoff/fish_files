function dockerfish --wraps='docker run -it --rm andreiborisov/fish:3' --wraps=docker --description 'alias dockerfish docker run -it --rm andreiborisov/fish:3'
  docker run -it --rm andreiborisov/fish:3 $argv; 
end
