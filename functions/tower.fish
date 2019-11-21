function tower -d "Open Tower for directory (default CWD)"
	open -a Tower (fallback $argv .)
end
