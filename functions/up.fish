function _up -d "inspired by `bd`: https://github.com/vigneshwaranr/bd"
  set -l rx (ruby -e "print '$argv'.gsub(/\s+/,'').split('').join('.*?')")
  # fish doesn't allow ${var} protection
  # so the square brackets are interpreted as array counters...
  set -l rx (printf "/(.*\/%s[^\/]*\/).*/i" $rx)
  echo $PWD | ruby -e "print STDIN.read.sub($rx,'\1')"
end

function up -d "cd to a parent folder with fuzzy matching"
  if test (count $argv) -eq 0
    echo "up: traverses up the current working directory to first match and cds to it"
    echo "Missing argument"
  else
    cd (_up "$argv")
  end
end
