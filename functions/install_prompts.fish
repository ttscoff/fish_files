function install_prompts
    set filter ""
    if test (count $argv) -gt 0
        set filter $argv[1]
    end
    install_vscode_prompts $filter
    install_cursor_commands $filter
end
