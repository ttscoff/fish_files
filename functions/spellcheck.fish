function spellcheck -d 'Check all Markdown files in git repo (recursive)'
	for file in (git ls-files|grep -v -E '(/|^)_'|grep -iE '\.(md|markdown)$')
		aspell -M --lang=en --dont-backup --home-dir=$HOME --personal=$HOME/aspell.txt check "$file"
	end
end
