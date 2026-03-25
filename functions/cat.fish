# requires: is, get_ext, warn, mdless
function cat -d "Use appropriate cat replacement for file type"
    # if calling from another function, use the original cat
    set -l current_command (string trim (status current-command))
    if test "$current_command" != cat
        command cat $argv
        return 0
    end

    # if calling from VS Code, Cursor, or Cursor Agent, use the original cat
    if string match -q "$TERM_PROGRAM" vscode
        or string match -q "$TERM_PROGRAM" cursor
        or string match -q "$TERM_PROGRAM" cursor-agent
        command cat $argv
        return 0
    end

    for file in $argv
        set -l exts md markdown txt taskpaper mmd mdown mdwn mkdn mkdown

        if not test -f $file
            echo "File not found:  $file"
            continue
        end

        if is image $file || is pdf $file
            # Use the `imgcat` command to display images in the terminal
            imgcat -r -W 50 $file
            continue
        end

        if is docx $file
            # Use the `docx2txt` command to convert docx files to plain text
            pandoc -t markdown_mmd -o - --wrap=none --reference-links $file | mdless
            continue
        end

        if is text $file
            if is markown $file || contains (get_ext  $file) $exts
                warn "Markdown file"
                if type -q apex
                    apex --to terminal256 $file
                else if type -q mdless
                    mdless $file
                else if type -q glow
                    glow $file
                else if type -q bat
                    command bat --style plain $file
                else
                    command cat $file
                end
            else
                if type -q bat
                    command bat --style plain $file
                else
                    command cat $file
                end
            end
            continue
        end

        # bat -A --style plain $files
        timeout 5 command cat $argv
    end

    return 0
end
