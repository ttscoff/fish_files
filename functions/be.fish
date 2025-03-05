function be --wraps bundle -d 'Run a command in the context of the current bundle'
    bundle exec $argv
    # Optionally, add more functionality or error handling here in the future
    if [ $? -ne 0 ]; then
        echo "Error: Command failed to execute."
    fi
end
