function pless -d 'cat a file with pygments highlighting'
	pygmentize -O "style=monokai" -g $argv | bat
end
