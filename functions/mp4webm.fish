function mp4webm -d "Convert mp4 to webm using ffmpeg"
    for arg in $argv
        if not string match -r -- '.*\.mp4$' -- $arg
            warn -e "Input file '$arg' does not have a .mp4 extension. Skipping."
            continue
        end
        set input_file $arg
        set output_file (string replace -r '\.mp4$' '.webm' -- $input_file)
        #        ffmpeg -i "$input_file" -vf scale=1280:720 -c:v libvpx-vp9 -b:v 1M -crf 28 -c:a libopus "$output_file"
        # ffmpeg -i "$input_file" -c:v libvpx-vp9 -b:v 1M -crf 28 -c:a libopus "$output_file"
        # Use VP9 encoding
        ffmpeg -i "$input_file" -c:v libvpx-vp9 -c:a libopus "$output_file"
    end
end
