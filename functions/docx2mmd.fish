function docx2mmd -d "Convert docx to markdown: docx2mmd [source] [target]"
    if test (count $argv) -ne 2
        echo "Error: You must provide a source and a target file."
        return 1
    end
    pandoc -o "$argv[2]" --wrap=none --reference-links --extract-media=(dirname "$argv[2]") "$argv[1]"
    return 0
end
