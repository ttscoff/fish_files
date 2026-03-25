# Defined via `source`
function mp4compress
    for arg in $argv
        if not string match -r -- '.*\.mp4$' -- $arg
            warn -e "Input file '$arg' does not have a .mp4 extension. Skipping."
            continue
        end
        set input_file $arg
        set output_file (string replace -r '\.mp4$' '.compressed.mp4' -- $input_file)
        ffmpeg -i "$input_file" -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k "$output_file"
    end
end
