
function td -d '[Create and] open project todo'

	set -l todofile ""
	set -l todos *.taskpaper

	if test (count $todos) -gt 0
		if test (count $argv) -gt 0
			set todofile (ls *.taskpaper|fzf -q $argv -1)
		else
			set todofile (ls *.taskpaper|fzf -1)
		end
	end

	if test -z $todofile
		# If you don't pass a name as an argument, it's pulled from the directory name
		set -l proj (basename $PWD)

		if ! test -z $argv
			set proj $argv
		end

		set todofile "$proj.taskpaper"

		if test ! -e $todofile
			touch $todofile
			echo -e "Inbox:\n$proj:\n\tNew Features:\n\tIdeas:\n\tBugs:\nArchive:\nSearch Definitions:\n\tTop Priority @search(@priority = 5 and not @done)\n\tHigh Priority @search(@priority > 3 and not @done)\n\tMaybe @search(@maybe)\n\tNext @search(@na and not @done and not project = \"Archive\")\n" >> $todofile
		end
	end

	open -a TaskPaper $todofile
end
