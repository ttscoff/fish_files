# Defined via `source`
function ogg --description 'Convert media to ogg using ffmpeg'
    argparse h/help q/quality= -- $argv
    or return

    if set -q _flag_help
        echo "Usage: ogg [OPTIONS] FILE [FILE...]"
        echo "Convert each input file to a .ogg file with the same basename."
        echo "  -h, --help   Show help"
        echo "  -q, --quality X   Set ffmpeg Vorbis quality (-q:a, 0-10)."
        echo "                    Defaults: OGG_Q env var, else 5."
        return 0
    end

    if set -q OGG_Q
        set ogg_q $OGG_Q
    else
        set ogg_q 5
    end

    if set -q _flag_quality
        set ogg_q $_flag_quality
    end

    if test (count $argv) -eq 0
        echo "Usage: ogg [OPTIONS] FILE [FILE...]"
        echo "Convert each input file to a .ogg file with the same basename."
        echo "Try 'ogg --help' for options."
        return 1
    end

    for file in $argv
        set output (string replace -r '\.[^./]+$' '.ogg' -- $file)
        if test "$output" = "$file"
            set output "$file.ogg"
        end

        # -vn: disable video stream
        # -c:a libvorbis: Vorbis audio codec in Ogg container
        # -q:a: variable bitrate quality (0-10, higher = better)
        ffmpeg -i $file -vn -c:a libvorbis -q:a $ogg_q $output
    end
end
