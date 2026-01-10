function port-ps --argument port -d 'Show processes using the specified port.'
    sudo lsof -Pi :$port
end
