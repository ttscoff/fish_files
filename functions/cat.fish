function cat -d "Use appropriate cat replacement for file type"
    for file in $argv
        set -l exts md markdown txt taskpaper mmd mdown mdwn mkdn mkdown

        if not test -f $file
            echo "File not found:  $file"
            continue
        end

        if is image $file || is pdf $file
            # Use the `imgcat` command to display images in the terminal
            imgcat $file
            continue
        end

        if is docx $file
            # Use the `docx2txt` command to convert docx files to plain text
            pandoc -t markdown_mmd -o - --wrap=none --reference-links $file | mdless
            continue
        end

        if is text $file
            if is markown $file || contains (get_ext  $file) $exts
                mdless $file
            else
                command bat --style plain $file
            end
            continue
        end

        bat -A --style plain $files
    end

    return 0
end
