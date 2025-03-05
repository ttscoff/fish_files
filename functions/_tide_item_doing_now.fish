# Adds an icon and duration if there's an active doing entry
# set -U tide_doing_now_color 3c2460
# set -U tide_doing_now_bg_color 000000
# set -U tide_doing_now_include_duration false
# set -U tide_doing_now_max_length 20
# set -U tide_doing_duration_format dhm
# In doing config
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
function _tide_item_doing_now
	set -l result $DOING_NOW #(doing view tide)
	if test -n "$result"
		set -l parts (string split "||" "$result")
		set -l doingnow $parts[2]
		set -l startdate $parts[1]

		set -q tide_doing_now_include_duration; or set -g tide_doing_now_include_duration true
		set -q tide_doing_now_max_length; or set -g tide_doing_now_max_length 20
		set -q tide_doing_duration_format; or set -g tide_doing_duration_format dhm
		set doingnow (string sub --length $tide_doing_now_max_length $doingnow)"…"

		if $tide_doing_now_include_duration
			and test -n "$startdate"
			set -l now (date '+%s')
			set -l seconds (math "$now - $startdate")
			set -l duration (/usr/bin/env ruby ~/.config/fish/functions/human_interval.rb $seconds dhm)
			set duration (string trim $duration)
			set doingnow "$doingnow ($duration)"
		end

		_tide_print_item doing_now $doingnow
	end
end
