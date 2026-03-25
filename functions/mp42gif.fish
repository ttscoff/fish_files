function mp42gif -d "Convert mp4 to gif"
    for arg in $argv
        if not string match -r -- '.*\.mp4$' -- $arg
            warn -e "Input file '$arg' does not have a .mp4 extension. Skipping."
            continue
        end
        set input_file $arg
        set output_file (string replace -r '\.mp4$' '.gif' -- $input_file)
        ffmpeg -y -i "$input_file" -filter_complex "fps=15,scale=800:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=32[p];[s1][p]paletteuse=dither=bayer" "$output_file"
    end
end
