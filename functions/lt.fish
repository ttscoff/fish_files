function lt -d "List directory from oldest to newest"
	ls -Atr1 $argv && echo (set_color -d white)"⇡⎽⎽⎽⎽Newest⎽⎽⎽⎽⇡"(set_color normal)
end
