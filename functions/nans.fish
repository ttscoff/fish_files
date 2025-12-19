function nans -d "Save the accepted answer from StackOverflow as Markdown to nvUltra"
    set -l notebook "/Users/ttscoff/Library/Mobile Documents/9CR7T2DMDG~com~ngocluu~onewriter/Documents/nvALT2.2/"

    argparse h/help a/all -- $argv
    if set -q _flag_help
        echo "ans - Get the accepted answer from StackOverflow as Markdown and save to nvUltra"
        echo
        echo "Usage: nans [search terms]"
        echo
        echo "Options:"
        echo "  -h, --help    Show this help message"
        echo "  -a, --all     Get all answers (default accepted only)"
        echo
        echo "Requirements:"
        echo "  - searchlink gem (install with: `gem install searchlink`)"
        echo "  - gather CLI (install with: `brew install gather`)"
        return 0
    end

    if set -q _flag_all
        gather --nvu-add --nvu-notebook $notebook (echo "!stackoverflow.com $argv!!" | searchlink)
    else
        gather --nvu-add --nvu-notebook $notebook --accepted-only (echo "!stackoverflow.com $argv!!" | searchlink)
    end

end
