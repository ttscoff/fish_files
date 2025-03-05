function _doing_is_active --description 'Check if doing is active'
    set -l result $DOING_NOW # (doing view tide)
	if test -n "$result"
        return 0
    else
        return 1
    end
end
