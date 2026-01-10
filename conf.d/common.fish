function slugify -d "Slugify a string"
    if test (count $argv) -eq 0
        command cat | string lower | stringify_numbers | add_dashes
    else
        echo $argv | string lower | stringify_numbers | add_dashes
    end
end

function unslugify -d "Unslugify a string"
    if test (count $argv) -eq 0
        command cat | sed -E 's/[_-]+/ /g' | unstringify_numbers
    else
        echo $argv | sed -E 's/[_-]+/ /g' | stringify_numbers
    end
end

function add_dashes -d "Add dashes between words in a string"
    if test (count $argv) -eq 0
        command cat | LC_ALL=C command iconv -t ascii//TRANSLIT | LC_ALL=C command sed -E 's/[^a-zA-Z0-9\-]+/-/g' | LC_ALL=C command sed -E 's/^(-|_)+|(-|_)+$//g'
    else
        echo $argv | LC_ALL=C command iconv -t ascii//TRANSLIT | LC_ALL=C command sed -E 's/[^a-zA-Z0-9\-]+/-/g' | LC_ALL=C command sed -E 's/^(-|_)+|(-|_)+$//g'
    end
end

function unstringify_numbers -d 'Convert strings like one to 1, twenty one to 21, three-dot-five to 3.5, zero-dot-three-dot-fifty-two to 0.3.52, etc.'

    python3 -c "import word2number" 2>/dev/null
    if test $status -ne 0
        if not status --is-interactive; or not set -q argv[1]
            echo 'Error: Python module "word2number" is required but not installed. Please install it with pip or pipx.' >&2
            return 1
        end
        echo 'The Python module "word2number" is required. Install with pip (1), pipx (2), or skip (3)? [1/2/3]:'
        read -l _unstringify_choice
        switch $_unstringify_choice
            case 1
                pip install --user word2number
            case 2
                pipx install word2number
            case 3
                echo 'Skipping install. Function will not work without the module.'
                return 1
        end
    end

    if count $argv >/dev/null
        python3 -c "
import sys
from word2number import w2n
def convert(arg):
    try:
        if '-dot-' in arg:
            parts = arg.split('-dot-')
            return '.'.join(str(w2n.word_to_num(p)) for p in parts)
        else:
            return str(w2n.word_to_num(arg))
    except Exception:
        return arg
for line in [' '.join(sys.argv[1:])]:
    tokens = line.split()
    print(' '.join(convert(token) for token in tokens))
" $argv
    else
        python3 -c "
import sys
from word2number import w2n
def convert(arg):
    try:
        if '-dot-' in arg:
            parts = arg.split('-dot-')
            return '.'.join(str(w2n.word_to_num(p)) for p in parts)
        else:
            return str(w2n.word_to_num(arg))
    except Exception:
        return arg
for line in sys.stdin:
    tokens = line.strip().split()
    print(' '.join(convert(token) for token in tokens))
"
    end
end


function stringify_numbers -d 'Convert numbers to strings like 1 to one, 21 to twenty one, 3.5 to three-dot-five, 0.3.52 to zero-dot-three-dot-fifty-two, etc.'

    python3 -c "import num2words" 2>/dev/null
    if test $status -ne 0
        if not status --is-interactive; or not set -q argv[1]
            echo 'Error: Python module "num2words" is required but not installed. Please install it with pip or pipx.' >&2
            return 1
        end
        echo 'The Python module "num2words" is required. Install with pip (1), pipx (2), or skip (3)? [1/2/3]:'
        read -l _stringify_choice
        switch $_stringify_choice
            case 1
                pip install --user num2words
            case 2
                pipx install num2words
            case 3
                echo 'Skipping install. Function will not work without the module.'
                return 1
        end
    end
    if count $argv >/dev/null
        python3 -c "
import sys
from num2words import num2words
def convert(arg):
    try:
        if '.' in arg:
            parts = arg.split('.')
            return '-dot-'.join(num2words(int(p)) for p in parts)
        else:
            return num2words(int(arg))
    except Exception:
        return arg
for line in [' '.join(sys.argv[1:])]:
    tokens = line.split()
    print(' '.join(convert(token) for token in tokens))
" $argv
    else
        python3 -c "
import sys
from num2words import num2words
def convert(arg):
    try:
        if '.' in arg:
            parts = arg.split('.')
            return '-dot-'.join(num2words(int(p)) for p in parts)
        else:
            return num2words(int(arg))
    except Exception:
        return arg
for line in sys.stdin:
    tokens = line.strip().split()
    print(' '.join(convert(token) for token in tokens))
"
    end
end

function shortest_common -d 'Find shortest common paths that group similar paths together'
    argparse h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: shortest_common PATH [PATH...]"
        echo ""
        echo "Find the shortest common paths that group similar paths together."
        echo "Paths that share a common prefix are grouped under the first path encountered."
        echo ""
        echo "Arguments:"
        echo "  PATH...            List of paths to process"
        echo ""
        echo "Options:"
        echo "  -h, --help         Show this help message"
        echo ""
        echo "Examples:"
        echo "  shortest_common /home/user/file1 /home/user/file2 /home/other/file3"
        echo "                     # Returns: /home/user/file1, /home/other/file3"
        echo "                     # (file2 shares prefix with file1, so it's grouped)"
        echo ""
        echo "Notes:"
        echo "  - The first path is always included in the results"
        echo "  - Remaining paths are sorted before processing"
        echo "  - Paths that start with an existing root path are grouped under that root"
        return 0
    end

    if test (count $argv) -eq 0
        echo "Error: shortest_common requires at least one path argument" >&2
        echo "Use -h or --help for usage information." >&2
        return 1
    end

    set -l root $argv[1]
    set -l results $argv[1]
    set -e argv[1]
    for path in (return_array $argv | sort)
        if not test (string match "$root*" $path)
            set root $path
            set -a results $path
        end
    end
    return_array $results
end

function __ff_dir_to_regex
    echo (printf '%s' (echo "$argv"|sed -E 's/ +//g'|sed -E 's/(.)/\1[^\/]*/g'))
end

function __ff_dir_regex
    set -l section
    set -l regex (__ff_dir_to_regex $argv[1])
    for arg in $argv[2..-1]
        set section (__ff_dir_to_regex $arg)
        set regex "$regex/[^.]*$section"
    end
    echo $regex
end

function __should_na --on-variable PWD
    # function __should_na --on-event fish_prompt
    test -s (basename $PWD)".taskpaper" && na
end

function __sort_by_length -d 'sort lines by length, lines passed as arguments'
    set lines (string join "\n" $argv)
    echo -e $lines | awk '{ print length(), $0 | "sort -n" }' | cut -d" " -f2-
end

function __by_length -d 'sort piped lines by length'
    command cat | awk '{ print length(), $0 | "sort -n" }' | cut -d" " -f2-
end

function remove_empty -d 'removes empty elements from an array'
    set -l result
    for item in $argv
        if test -n (string replace -a ' ' '' $item)
            set -a result $item
        end
    end
    echo -en (string join "\n" $result)
end

function trim_pwd -d 'removes the current working directory from an array of paths'
    set -l wd (pwd)
    if test (count $argv) -gt 0
        echo -en $argv | sed -E "s%^($wd|\.)/%%" | sed -E "s%^$wd/?\$%.%"
    else
        while read line
            echo -e $line | sed -E "s%^($wd|\.)/%%" | sed -E "s%^$wd/?\$%.%"
        end
    end
end

function return_array -d 'Echo out an array one line at a time'
    for item in $argv
        echo $item
    end
end

function shorten_home -d 'substitutes $HOME with ~'
    set -l wd $HOME
    if test (count $argv) -gt 0
        echo -en $argv | sed -E "s%^$wd%~%"
    else
        while read line
            echo -e $line | sed -E "s%^$wd%~%"
        end
    end
end

function append_slash -d 'append a slash to each line/argument if needed'
    if test (count $argv) -gt 0
        echo -en $argv | sed -E 's%/?$%/%'
    else
        while read line
            echo -e $line | sed -E 's%/?$%/%'
        end
    end
end


function slash_if_dir -d 'Add trailing slash if directory'
    if test -d $argv
        append_slash $argv
    else
        echo -en $argv
    end
end

function reload_func -d 'Reload a fish function from its source file'
    functions -e $argv[1]
    src
end
