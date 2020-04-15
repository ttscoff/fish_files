function tower -d "Open Tower for directory (default CWD)"
	open (git rev-parse --show-toplevel) -a Tower
end
