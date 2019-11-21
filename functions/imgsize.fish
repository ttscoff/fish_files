# Defined in /Users/ttscoff/.config/fish/brett.fish @ line 141
function imgsize --description 'Quickly get image dimensions from the command line'
	if test -f $argv
    set -l height (sips -g pixelHeight "$argv"|tail -n 1|awk '{print $2}')
    set -l width (sips -g pixelWidth "$argv"|tail -n 1|awk '{print $2}')
    echo "$width x $height"
  else
    echo "File not found"
  end
end
