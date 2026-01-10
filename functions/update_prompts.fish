function update_prompts -d 'Update prompt and command files in .github/prompts and .cursor/commands from dotfiles.'
    set -l src_vscode ~/dotfiles/github/prompts
    set -l dst_vscode .github/prompts
    set -l src_cursor ~/dotfiles/cursor/commands
    set -l dst_cursor .cursor/commands

    # Ensure destination directories exist
    mkdir -p $dst_vscode
    mkdir -p $dst_cursor

    # Helper to process a folder
    function process_folder --argument-names src dst
        for file in (ls $src)
            set src_file $src/$file
            set dst_file $dst/$file
            if not test -e $dst_file
                echo "Copying new file: $file to $dst_file"
                cp $src_file $dst_file
            else
                # Show diff and prompt for update
                if not diff -q $src_file $dst_file >/dev/null
                    echo "Difference found in $dst_file:"
                    delta --side-by-side $dst_file $src_file
                    read -l -P "Update $dst_file with changes? (y/N): " confirm
                    if test "$confirm" = y
                        cp $src_file $dst_file
                        echo "Updated $file in $dst"
                    else
                        echo "Skipped $dst/$file"
                    end
                end
            end
        end
    end

    process_folder $src_vscode $dst_vscode
    process_folder $src_cursor $dst_cursor
end
