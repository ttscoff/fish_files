function mp4poster -d "Create a poster image from MP4 files"
    argparse 'f/frame=' h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: mp4poster [-f N|--frame N] [file1.mp4 ...]"
        echo "Options:"
        echo "  -f, --frame N   Frame number to extract (default: 1)"
        echo "  -h, --help      Show this help message"
        return 0
    end

    set frame 1
    if set -q _flag_frame
        set frame $_flag_frame
    end

    for arg in $argv
        if not string match -r -- '.*\.mp4$' -- $arg
            warn -e "Input file '$arg' does not have a .mp4 extension. Skipping."
            continue
        end
        set input_file $arg
        set output_file (string replace -r '\.mp4$' '.jpg' -- $input_file)
        ffmpeg -i "$input_file" -vf "select=eq(n\,$frame)" -vframes 1 "$output_file"
        jpegoptim -fopt --strip-all -m65 -T10 "$output_file"
    end
end
