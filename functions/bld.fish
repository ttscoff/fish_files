function bld -d "Run howzit build system"
	howzit -r (fallback $argv build)
end
