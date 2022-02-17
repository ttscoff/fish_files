# Adds an icon and duration if there's an active doing entry
# set -U tide_doing_icon 
# set -U tide_doing_color ff0000
# set -U tide_doing_active_include_duration false
#
# In doing config:
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
function _tide_item_doing_active
	set -l result (doing view tide)
	if test -n "$result"
		set parts (string split "||" "$result")
		set doingnow $parts[1]
		set duration $parts[2]
		set output $tide_doing_icon
		if set -q tide_doing_active_include_duration
			and $tide_doing_active_include_duration
			set output "$output($duration)"
		end
		_tide_print_item doing_active (set_color -b $tide_doing_bg_color; set_color $tide_doing_color) $output
	end
end
