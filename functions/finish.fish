function finish --wraps=doing --description 'Finish last unfinished doing task by search'
    doing finish -u --search="$argv" 1
end
