function gt -d "jump to top level of git repo"

    if test (count $argv) -gt 0
        echo "Warning: Any additional arguments will be ignored."
    end

    cd (git rev-parse --show-toplevel) $argv
end
