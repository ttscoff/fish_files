function getignores -d 'pull gitignore.io list of available .gitignore files'
	curl -SsL https://www.gitignore.io/api/list 2>/dev/null | tr ',' "\n" | grep --color=never "$argv"
end
