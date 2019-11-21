function ltr -d "List directory from newest to oldest"
	ls -At1 $argv && echo (set_color -d white)"⇡⎽⎽⎽⎽Oldest⎽⎽⎽⎽⇡"(set_color normal)
end
