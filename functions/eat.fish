function eat --description 'Move files from a directory to the current directory'
    argparse f/force h/help -- $argv
    or return 1
    if set -q _flag_help
        echo "Usage: eat [-f|--force] DIR"
        echo "Move files from DIR to the current directory, then remove DIR."
        echo "  -f, --force      Overwrite existing files in the current directory."
        echo "  -h, --help       Show this help message."
        return 0
    end
    set -l force 0
    if set -q _flag_force
        set force 1
    end
    set -l dir $argv[1]
    if test -z "$dir"
        echo (status function): argument must be a directory
        return 1
    end
    if not test -d $dir
        echo (status function): directory does not exist: $dir
        return 1
    end
    set files_to_move (find $dir -maxdepth 1 -not -path $dir)

    for f in $files_to_move
        set filename (echo $f | string replace $dir '' | trim-left /)
        if test $force -eq 0
            if file-exists ./$filename
                echo "eat: file would be overwritten: ./$filename"
                return 1
            end
        end
    end

    set target (dirname $dir)

    for f in $files_to_move
        mv -f $f $target
    end

    rmdir $dir
end
