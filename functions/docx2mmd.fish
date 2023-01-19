function docx2mmd -d "Convert docx to markdown: docx2md [source] [target]"
	pandoc -o "$argv[2]" --wrap=none --reference-links --extract-media=(dirname "$argv[2]") "$argv[1]"
end
