function avif --description 'Convert images to avif using avifenc'
    argparse h/help q/quality= -- $argv
    or return

    if set -q _flag_help
        echo "Usage: avif [-q X,Y|--quality X,Y] FILE [FILE...]"
        echo "Convert each input image to a .avif file with the same basename."
        echo "  -q, --quality X,Y   Set avifenc --min/--max quality values."
        echo "                      Defaults: AVIF_MIN_Q/AVIF_MAX_Q env vars, else 20,35."
        return 0
    end

    if set -q AVIF_MIN_Q
        set avif_min_q $AVIF_MIN_Q
    else
        set avif_min_q 20
    end

    if set -q AVIF_MAX_Q
        set avif_max_q $AVIF_MAX_Q
    else
        set avif_max_q 35
    end

    if set -q _flag_quality
        set -l q_parts (string split ',' -- $_flag_quality)
        if test (count $q_parts) -ne 2
            echo "Invalid quality '$_flag_quality'. Expected format: X,Y"
            return 1
        end

        set avif_min_q (string trim -- $q_parts[1])
        set avif_max_q (string trim -- $q_parts[2])
    end

    if test (count $argv) -eq 0
        echo "Usage: avif [-q X,Y|--quality X,Y] FILE [FILE...]"
        echo "Convert each input image to a .avif file with the same basename."
        echo "Try 'avif --help' for options."
        return 1
    end

    for file in $argv
        set output (string replace -r '\.[^./]+$' '.avif' -- $file)
        if test "$output" = "$file"
            set output "$file.avif"
        end

        avifenc --min $avif_min_q --max $avif_max_q $file $output
    end
end
