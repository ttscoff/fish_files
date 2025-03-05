function gitrelease -d 'Create a git release using hub'
    if test -z "$argv"
        echo "Please provide a version number."
        return 1
    end

    hub release create -m "v$argv" $argv

    echo "Release created successfully for version v$argv."
end
