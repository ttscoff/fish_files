function gitar -d "Automatically add new and remove deleted files from the git index"
	pushd (git rev-parse --show-toplevel)
	git ls-files -d -m -o -z --exclude-standard | xargs -0 git update-index --add --remove
	popd
end
