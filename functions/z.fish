function z --description 'Custom fasd cd with fzf'
	set -l tgt_dir (fasd -dlR $argv | fzf -1 -0)
	if [ (echo $tgt_dir) ]
		cd "$tgt_dir"
	end
end
