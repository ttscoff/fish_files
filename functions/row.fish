function row --argument index -d 'Print the specified line number from input.'
    sed -n "$index p"
end
