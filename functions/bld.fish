function bld -d "Run howzit build system"
	if test (count $argv) -gt 1
		howzit -r $argv[1] -- $argv[2..-1]
	else
		howzit -r (fallback $argv build)
	end
end
