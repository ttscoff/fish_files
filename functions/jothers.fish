function jothers -d 'jtag: List tags of other posts containing (all) tags'
	jtag tags (jtag posts_tagged -b AND $argv)
end

