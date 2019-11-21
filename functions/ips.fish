function ips -d 'Display all ip addresses for this host'
	ifconfig | grep "inet " | awk '{ print $2 }'
	echo "External: "(ip)
end
