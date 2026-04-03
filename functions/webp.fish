function webp --description 'Convert images to webp using cwebp'
    argparse h/help q/quality= -- $argv
    or return

    if set -q _flag_help
        echo "Usage: webp [-q X|--quality X] FILE [FILE...]"
        echo "Convert each input image to a .webp file with the same basename."
        echo "  -q, --quality X   Set cwebp quality value."
        echo "                    Defaults: WEBP_Q env var, else 82."
        return 0
    end

    if set -q WEBP_Q
        set webp_q $WEBP_Q
    else
        set webp_q 82
    end

    if set -q _flag_quality
        set webp_q $_flag_quality
    end

    if test (count $argv) -eq 0
        echo "Usage: webp [-q X|--quality X] FILE [FILE...]"
        echo "Convert each input image to a .webp file with the same basename."
        echo "Try 'webp --help' for options."
        return 1
    end

    for file in $argv
        set output (string replace -r '\.[^./]+$' '.webp' -- $file)
        if test "$output" = "$file"
            set output "$file.webp"
        end

        cwebp -q $webp_q $file -o $output
    end
end
