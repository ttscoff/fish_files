function bld -d "Run howzit build system"
	if test (count $argv) -gt 1
		howzit -r $argv
	else
		howzit -r (fallback $argv build)
	end
end
