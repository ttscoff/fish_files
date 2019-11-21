function calc -d "CLI calculator"
	set -l equation (string replace -ra '[^0-9.+/*()-]' "" $argv)
	echo "scale = 4; $equation" | bc -lq
end
