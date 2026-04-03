function gifmp4 -d "Convert gif to mp4 using ffmpeg"
    for arg in $argv
        if not string match -r -- '.*\.gif$' -- $arg
            warn -e "Input file '$arg' does not have a .gif extension. Skipping."
            continue
        end
        set input_file $arg
        set output_file (string replace -r '\.gif$' '.mp4' -- $input_file)
        ffmpeg -i "$input_file" -movflags +faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$output_file"
    end
end
