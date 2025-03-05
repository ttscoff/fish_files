function mmdc -d "Open MultiMarkdown Composer 5 with optional file (completion available)"
    if test (count $argv) -eq 0
        echo "No file specified. Please provide a file to open."
        return 1
    end
    open -a '/Applications/MMDComposer5.app' $argv
end
