function webm --description 'Convert video to webm using ffmpeg'
    argparse h/help q/quality= -- $argv
    or return

    if set -q _flag_help
        echo "Usage: webm [OPTIONS] FILE [FILE...]"
        echo "Convert each input file to a .webm file with the same basename."
        echo "  -h, --help   Show help"
        echo "  -q, --quality X   Set ffmpeg VP9 CRF quality (lower = better)."
        echo "                    Defaults: WEBM_CRF env var, else 30."
        return 0
    end

    if set -q WEBM_CRF
        set webm_crf $WEBM_CRF
    else
        set webm_crf 30
    end

    if set -q _flag_quality
        set webm_crf $_flag_quality
    end

    if test (count $argv) -eq 0
        echo "Usage: webm [OPTIONS] FILE [FILE...]"
        echo "Convert each input file to a .webm file with the same basename."
        echo "Try 'webm --help' for options."
        return 1
    end

    for file in $argv
        set output (string replace -r '\.[^./]+$' '.webm' -- $file)
        if test "$output" = "$file"
            set output "$file.webm"
        end

        # -c:v libvpx-v9: VP9 video codec
        # -crf: quality (lower = better, typical 24–32)
        # -b:v 0: use CRF-based quality, not target bitrate
        #-c:a libopus: Opus audio (modern, efficient)
        ffmpeg -i $file -c:v libvpx-vp9 -crf $webm_crf -b:v 0 -c:a libopus $output
    end
end
