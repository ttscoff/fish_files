function vimver --description 'Open the version file of the current gem in vim'
    set -l path (git rev-parse --show-toplevel 2> /dev/null)
    set -l name (basename $path/*.gemspec .gemspec)
    vim $path/lib/**/version.rb
end
