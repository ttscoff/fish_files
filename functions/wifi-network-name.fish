function wifi-network-name --description 'Get the name of the current wifi network'
    set -l wifi_name (networksetup -getairportnetwork en0 | awk '{print $4}')
    if test -n "$wifi_name"
        echo $wifi_name
    else
        echo "Not connected to any Wi-Fi network"
    end
end
