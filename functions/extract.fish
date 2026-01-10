function extract --description 'unarchive any file type'
    argparse 't/to=' h/help -- $argv
    or return 1
    if set -q _flag_help
        echo "Usage: extract [-t DIR|--to DIR] FILE"
        echo "  -t DIR, --to DIR   Extract to DIR instead of file's directory."
        echo "  -h, --help         Show this help message."
        echo "Unarchive any file type to the specified directory."
        return 0
    end
    set -l output_dir ''
    if set -q to
        set output_dir $to
    else if set -q _flag_to
        set output_dir $_flag_to
    else if set -q _flag_t
        set output_dir $_flag_t
    end
    if test (count $argv) -ne 1
        warn -e "Error: You must specify exactly one file to extract."
        return 1
    end
    set -l file_arg $argv[1]
    if test -z "$file_arg"
        warn -e "Error: No file specified."
        return 1
    end
    set -l f $file_arg
    if test -f $f
        set -l abs_f (realpath $f)
        set -l orig_dir (pwd)
        if test -n "$output_dir"
            mkdir -p $output_dir
            cd $output_dir
        else
            cd (dirname $abs_f)
        end
        switch $abs_f
            case '*.docx'
                set -l dir (basename "$abs_f" ".docx")
                command unzip -o -d "$dir" $abs_f
            case '*.tar.bz2'
                tar xvjf $abs_f
            case '*.tar.gz'
                tar xvzf $abs_f
            case '*.bz2'
                bunzip2 $abs_f
            case '*.rar'
                unrar x $abs_f
            case '*.gz'
                gunzip $abs_f
            case '*.tar'
                tar xvf $abs_f
            case '*.tbz2'
                tar xvjf $abs_f
            case '*.tgz'
                tar xvzf $abs_f
            case '*.zip'
                unzip $abs_f
            case '*.Z'
                uncompress $abs_f
            case '*.7z'
                7z x $abs_f
            case '*'
                warn -e "'$abs_f' cannot be extracted"
        end
        cd $orig_dir
    else
        warn -e "'$f' is not a valid file"
    end
end
