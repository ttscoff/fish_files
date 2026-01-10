function todos --wraps=ack -d 'Search for TODOs and FIXMEs in the current directory'
    # Check if arguments were provided
    # if test (count $argv) -eq 0
    #     echo "Error: No search term provided."
    #     return 1
    # end

    # ack --nobreak --nocolor "(TODO|FIXME):" | sed -E "s/(.*:[[:digit:]]+):.*((TODO|FIXME):.*)/\2 :>> \1/" | grep -E --color=always ":>>.*:\d+" $argv
    cursor-agent --output-format text --print agent "show me all TODO: and FIX(ME): lines in any .m files, .rb files, and .js files (exclude any directory titled 'unused', 'lib', or 'vendor'). output filepath:line_no before each item (so that I can use iTerm's command-click to open the file to the right line number). Don't put any quotes or backticks around the lines. Remove the comment marker (//) and any whitespace at the beginning of the lines, leaving just one space between the filename:lineno and the todo item." -b
end
