function spellcheck -d 'Check all Markdown files in git repo (recursive)'
	set -l options (fish_opt -s c -l changed)
	set options $options (fish_opt -s h -l help)

	argparse --name=spellcheck $options -- $argv

	if set -q _flag_help
		echo "Spell check Markdown files"
		echo "Usage: spellcheck FILE"
		echo
		echo "If no file is specified, all Markdown files in git repository are spell checked."
		echo
		echo "Options:"
		echo "  -c/--changed Only spell check recently changed files"
		return
	end

	if test (count $argv) -gt 0
		for file in $argv
			aspell -M --lang=en --dont-backup --home-dir=$HOME --personal=$HOME/aspell.txt check "$file"
		end
	else
		set -l files
		if set -q _flag_changed
			set -a files (git diff --name-only HEAD~2|grep --color=never -iE '\.(md|markdown)$')
		else
			set -a files (git ls-files|grep -iE '\.(md|markdown)$')
		end

		if test (count $files) -gt 5
			set -l res (read -n 1 -P (set_color brwhite)"Spell check "(set_color brred)(count $files)(set_color brwhite)" files? "(set_color normal))
			if test "$res" != "y"
				return
			end
		end

		for file in $files
			aspell -M --lang=en --dont-backup --home-dir=$HOME --personal=$HOME/aspell.txt check "$file"
		end
	end
end
