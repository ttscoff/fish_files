# Fish completion for c.

# Complete with available commands from .cursor/commands/*.md (relative to PWD)
function __c_dot_complete_commands
    set -l cmd_dir ".cursor/commands"
    if test -d $cmd_dir
        for file in (find $cmd_dir -maxdepth 1 -type f -name '*.md' 2>/dev/null)
            echo (basename $file .md)
        end
    end
end

# Register completions for c.
complete -c c. -F -a '(__c_dot_complete_commands)' -d 'Directories and available commands'
