function index_of --description 'return the 1-based index of the first argument in remaining arguments'
  set -l needle $argv[1]
  set -e argv[1]
  set -l counter 0
  for item in $argv
    set counter (math $counter + 1)
    if test (string match $item $needle)
      echo $counter
      return
    end
  end
end
