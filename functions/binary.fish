function binary -d 'Convert a number to binary using bc.'
    echo "obase=2;$argv" | bc
end
