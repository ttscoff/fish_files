function last_history_item --description 'Return the last item from command history'
    set last_item $history[1]
    echo $last_item
end
