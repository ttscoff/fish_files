function __best_pager -d 'Choose the best available pager (opinionated)'
	# if test -n "$PAGER"
	# 	echo $PAGER
	# 	return 0
	# else
		set -l pagers bat nvimpager vimpager less more
		for pg in $pagers
			if __exec_available $pg
				echo $pg
				return 0
			end
		end
	# end
	echo "more"
end
