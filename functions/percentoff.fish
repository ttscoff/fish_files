
function percentoff -d 'Quick calculation for sale discounts'
	if test (count $argv) -ne 2
		echo "Usage: percentoff ORIG NEW"
		return 1
	end
	printf "%0.0f%%" (echo "scale = 10;100-(($argv[2]/$argv[1])*100)"|bc -lq)
end
