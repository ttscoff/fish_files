function pg --wraps='ps -ax | grep -i' --description 'Case insensitive search for process'
    ps -ax | grep -i $argv | less
    # Use less for paginated output
end
