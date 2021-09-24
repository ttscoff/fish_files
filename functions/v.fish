function v -d 'vim via fasd and fzf'
	set -l tgt (fasdfzf -f $argv)
  if [ (echo $tgt) ]
    vim "$tgt"
  end
end
