function b --description 'Run a binstub from the current project with bundler'
    set -l path (git rev-parse --show-toplevel 2> /dev/null)
    if test -z "$path"
        echo "Error: Not a git repository"
        return 1
    end
    set -l gemspecs (ls $path/*.gemspec 2> /dev/null)
    if test (count $gemspecs) -eq 0
        echo "Error: No gemspec files found in the project"
        return 1
    end
    set -l name (basename $gemspecs .gemspec)
    if test -f "bin/$name"
        bundle exec bin/$name $argv
    else
        echo "Error: Binstub '$name' does not exist"
        return 1
    end
end
