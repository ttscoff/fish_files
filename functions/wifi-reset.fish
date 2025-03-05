function wifi-reset --description 'Reset the Wi-Fi connection'
    # Turn off the Wi-Fi
    networksetup -setairportpower en0 off
    # Wait for a moment before turning it back on
    sleep 2
    # Turn on the Wi-Fi
    networksetup -setairportpower en0 on
end
