
function percentof -d 'Quick calculation for sale discounts'
	if test (count $argv) -ne 2
		echo "Usage: percentof ORIG PERCENT"
		return 1
	end

	set -l percent (string replace "%" "" $argv[2])

	printf '$%0.2f' (echo "scale = 10;$argv[1]-($argv[1] * ($percent/100))"|bc -lq)
end
