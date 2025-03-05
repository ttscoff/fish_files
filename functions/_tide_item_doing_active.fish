# Adds an icon and duration if there's an active doing entry
# set -U tide_doing_icon 
# set -U tide_doing_color ff0000
# set -U tide_doing_active_include_duration false
# set -U tide_doing_duration_format dhm
#
# In doing config:
#
# views:
#   tide:
#     date_format: "%s"
#     section: All
#     count: 1
#     order: desc
#     template: "%date||%title||%duration||%@tags"
#     tags: done
#     tags_bool: NONE
#     duration: true
#     interval_format: dhm
function _tide_item_doing_active
	set -l result $DOING_NOW # (doing view tide)
	if test -n "$result"
		set -l parts (string split "||" "$result")
		set -l startdate $parts[1]

		set -q tide_doing_active_include_duration; or set -g tide_doing_active_include_duration true
		set -q tide_doing_active_icon; or set -g tide_doing_active_icon 
		set -q tide_doing_duration_format; or set -g tide_doing_duration_format dhm

		set output $tide_doing_active_icon

		if $tide_doing_active_include_duration
			and test -n "$startdate"
			set -l now (date '+%s')
	  # set -l seconds (math "$now - $startdate")
			set -l duration (/usr/bin/env ruby ~/.config/fish/functions/human_interval.rb "$startdate" "$now" "$tide_doing_duration_format")
			set duration (string trim $duration)
			set output "$output($duration)"
		end

		_tide_print_item doing_active $output
	end
end
