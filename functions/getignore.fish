function getignore -d 'Get ignore file from gitignore.io and save to .gitignore'
	curl -SsL https://www.gitignore.io/api/$argv 2>/dev/null >>.gitignore
end
