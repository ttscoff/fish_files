function coln -d 'Print the specified column from input using awk.'
    awk '{print $'$argv[1]'}'
end
