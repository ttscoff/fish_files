# Defined in /var/folders/q7/sps8n5_534q22bx1ts4xjjl00000gn/T//fish.cfOq0N/fix.fish @ line 2
function fix --description 'Fix up last command with search/replace'
	if test (count $argv) -ne 2
    echo "Usage: fix SEARCH REPLACE"
    exit 1
  end
  set -l cmd (history --max=1|sed -e 's/^ +//'|sed -e "s/$argv[1]/$argv[2]/")
  commandline -r $cmd
end
