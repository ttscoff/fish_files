function mem --description 'Show memory usage'
    command top -o rsize $argv
end
