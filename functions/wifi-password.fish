function wifi-password --description 'Get the password for the current wifi network'
    set -l wifi_name (wifi-network-name)
    if test "$wifi_name" != "Not connected to any Wi-Fi network"
        security find-generic-password -wa "$wifi_name"
    else
        echo "Cannot retrieve password: $wifi_name"
    end
end
