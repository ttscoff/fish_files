function gifwebm -d "Convert gif to webm using ffmpeg"
    for arg in $argv
        if not string match -r -- '.*\.gif$' -- $arg
            warn -e "Input file '$arg' does not have a .gif extension. Skipping."
            continue
        end
        set input_file $arg
        set output_file (string replace -r '\.gif$' '.webm' -- $input_file)
        #        ffmpeg -i "$input_file" -vf scale=1280:720 -c:v libvpx-vp9 -b:v 1M -crf 28 -c:a libopus "$output_file"
        # ffmpeg -i "$input_file" -c:v libvpx-vp9 -b:v 1M -crf 28 -c:a libopus "$output_file"
        # Use VP9 encoding
        ffmpeg -y -i "$input_file" -vf scale=out_color_matrix=bt709:out_range=tv -pix_fmt yuva420p -bsf:v vp9_metadata=color_space=bt709:color_range=tv "$output_file"
    end
end
