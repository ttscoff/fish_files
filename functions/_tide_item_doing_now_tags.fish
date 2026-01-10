# Shows just the tags from the last unfinished entry
# set -U tide_doing_now_color 3c2460
# set -U tide_doing_now_bg_color 000000
# set -U tide_doing_now_include_duration false
# set -U tide_doing_now_max_length 20
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
function _tide_item_doing_now_tags
	set -l result (doing view tide)
	if test -n "$result"
		set parts (string split "||" "$result")
		set tags $parts[4]

		_tide_print_item doing_now_tags $tags
	end
end
