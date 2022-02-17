# Adds an icon and duration if there's an active doing entry
# set -U tide_doing_now_color 3c2460
# set -U tide_doing_now_bg_color 000000
# set -U tide_doing_now_include_duration false
# set -U tide_doing_now_max_length 20
# In doing config
#
# views:
# tide:
#   section: All
#   count: 1
#   order: desc
#   template: "%title||%duration"
#   tags: done
#   tags_bool: NONE
#   duration: true
#   interval_format: dhm
function _tide_item_doing_now
	set -l result (doing view tide)
	if test -n "$result"
		set parts (string split "||" "$result")
		set doingnow $parts[1]
		set duration $parts[2]

		if set -q tide_doing_now_max_length
			set doingnow (string sub --length $tide_doing_now_max_length $doingnow)"..."
		else
			set doingnow (string sub --length 20 $doingnow)"..."
		end

		if set -q tide_doing_now_include_duration
			and $tide_doing_now_include_duration
			set doingnow "$doingnow ($duration)"
		end
		_tide_print_item doing_now (set_color -b $tide_doing_now_bg_color; set_color $tide_doing_now_color) $doingnow
	end
end
