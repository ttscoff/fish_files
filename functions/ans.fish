function ans --description 'Get the accepted or all answers from StackOverflow as Markdown'
    argparse h/help a/all -- $argv
    if set -q _flag_help
        echo "ans - Get the accepted answer from StackOverflow as Markdown"
        echo
        echo "Usage: ans [search terms]"
        echo
        echo "Options:"
        echo "  -h, --help    Show this help message"
        echo "  -a, --all     Show all answers (default accepted only)"
        echo
        echo "Requirements:"
        echo "  - searchlink gem (install with: `gem install searchlink`)"
        echo "  - gather CLI (install with: `brew install gather`)"
        return 0
    end

    if set -q _flag_all
        gather (echo "!stackoverflow.com $argv!!" | searchlink)
    else
        gather --accepted-only (echo "!stackoverflow.com $argv!!" | searchlink)
    end

end
