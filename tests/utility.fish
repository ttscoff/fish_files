@test "Returns shortest argument" (shortest "123" "1234" "12345" "12") -eq 12

@test "Returns the correct directory" (ffdir -i -d2 (ffmark fish) func) = /Users/ttscoff/.config/fish/functions

@test "bat is available" (__exec_available bat) $status -eq 0
@test "batshit is not available" (__exec_available batshit) $status -eq 1

@test "Returns bat" (__best_pager) = bat

@test "Returns config.fish" (/usr/bin/env ruby ~/scripts/filecomplete.rb fish config) = "config.fish	.fish file"
