# Brett's Fish Files

A collection of configuration files and functions for the Fish shell. These would be installed in `~/.config/fish/`, though I don't recommend overwriting your current setup wholesale. Pick and choose, use this repo as examples for your own exploration.

## The parts

__bash_scripts__: some utilities that were too much trouble to port from Bash and work just as well run with hashbangs. They just need to be in the $PATH.

__completions__: various completion configurations for custom commands.

__custom__: some files I source at login (from `config.fish`), mostly shared functions I prefer to have in memory (as opposed to autoloaded), and some aliases I just haven't gotten around to turning into autoloaded functions yet.

__functions__: the motherload. All of my favorite commands (and some experimental ones). Most have a description on the function declaration, so you can see it in source or by running the `describe` command that you'll find in this folder (which essentially runs `functions -Dv`, but prettier).

## All the functions

- `64enc`: encode a given image file as base64 and output css background property to clipboard
- `64font`: encode a given font file as base64 and output css background property to clipboard
- `__auto_dir`: if command fails see if it\'s a directory or local executable
- `__prev_token`: Get the previous token on the command line
- `__re_extension`: remove extension from word under/before cursor
- `__regex_from_args`: Helper to create greedy regular expression from multiple arguments
- `ack`: ack defaults, ~/.ackrc for more
- `acorn`: Open Acorn.app with optional file(completion available)
- `add_user_path`: Shortcut to add a user path
- `affd`: Open Affinity Designer with optional file (completion available)
- `afff`: Open Affinity Photo with optional file (completion available)
- `ag`: Silver Surfer defaults, smart case, ignore VCS
- `alpha`: Open ImageAlpha with optional file (completion available)
- `ax`: Make file executable
- `bak`: move file to .bak version
- `bid`: Get bundle id for app name
- `bld`: Run howzit build system
- `browser`: Write output to a temp HTML file and open in default browser
- `calc`: CLI calculator
- `cat`: Use bat instead of cat unless it\'s a Markdown file, then use mdless
- `cdd`: Choose cd dir from menu (fzf)
- `cdt`: Change dir based on TagFiler tags
- `chrome`: Open Google Chrome with optional file (completion available)
- `cl`: copy output of last command to clipboard
- `clip`: Copy file to clipboard
- `code`: Open VSCode with optional file
- `cpwd`: Copy the current directory path to the clipboard
- `crush`: pngcrush
- `dash`: Open argument in Dash
- `ddg`: search duckduckgo
- `degit`: Remove all traces of git from a folder
- `describe`: Show description for function
- `dirfor`: get origin directory for running process
- `dman`: Open man page in Dash
- `docx2mmd`: Convert docx to markdown: docx2md [source] [target]
- `er`: edit recent file using fasd and fzf
- `esc`: Ruby cgi unescape
- `eschtml`: Ruby cgi HTML escape
- `extract`: unarchive any file type
- `f`: Open directory in Finder
- `fish_prompt`: Write out the prompt; do not replace this. Instead, change fish_prompt before sourcing .iterm2_shell_integration.fish, or modify iterm2_fish_prompt instead.
- `fisher`: fish package manager
- `fix`: Fix up last command with search/replace
- `flush`: Flush DNS cache
- `fp`: Find and list processes matching a case-insensitive fuzzy-match string
- `ft`: A shortcut for mdfinding tagged items system-wide
- `fuck`: Correct your previous console command
- `gc`: git commit -am
- `getignore`: Get ignore file from gitignore.io and save to .gitignore
- `getignores`: Pull gitignore.io list of available .gitignore files
- `gg`: Commit pending changes and quote all args as message
- `gitar`: Automatically add new and remove deleted files from the git index
- `gmine`: Resolve git conflicts with mine
- `gsearch`: Grep git commit history
- `gt`: jump to top level of git repo
- `gtheirs`: Resolve git conflicts with theirs
- `hs`: Search, select, and exec from history
- `imdown`: Test for internet connection and notify when it comes up
- `imgsize`: Quickly get image dimensions from the command line
- `ip`: Get external IP address
- `ips`: Display all ip addresses for this host
- `istext`: test if given file is plain text
- `js`: lint with jslint
- `lb`: Select file in LaunchBar, fall back to the current directory
- `lbash`: launch bash login shell
- `lno`: Print file with line numbers
- `lsgrep`: Wildcard folder/file search
- `lsz`: ls for inside of compressed archives
- `lt`: List directory from oldest to newest
- `ltr`: List directory from newest to oldest
- `mack`: ack for markdown
- `mkdir`: mkdir with subdirs, option to cd after creating
- `mmdc`: Open MultiMarkdown Composer with optional file (completion available)
- `nope`: echo "nope"
- `o`: Shortcut to open an app from the command line
- `optim`: Open ImageOptim with optional file (completion available)
- `percentof`: Quick calculation for sale discounts
- `percentoff`: Quick calculation for sale discounts
- `pless`: cat a file with pygments highlighting
- `pman`: Display a man page as a PostScript PDF in Preview.app
- `prev`: Open Preview with optional file (completion available)
- `preview`: Preview text files using fzf and bat
- `prioritize`: set a numeric prefix on a file for sorting
- `r`: Run Reiki via bash
- `rule`: Print a horizontal rule
- `rulem`: Print a horizontal rule with message
- `rvm`: Ruby enVironment Manager
- `serve`: Start a local server for the current directory, open in browser
- `shellesc`: Ruby shellwords escape
- `shellunesc`: Ruby shellwords unescape
- `shorten`: Truncate every line of input to specified width
- `spell`: Get spelling options from aspell
- `spellf`: Get spelling options from aspell
- `sublp`: Open a Sublime Text project (completion available)
- `sum`: Take a list of numbers and return the sum
- `td`: [Create and] open project todo
- `tmj`: For use with my tmux utility (bash_scripts/tm)
- `tower`: Open Tower for directory (default CWD)
- `tp`: Open TaskPaper with optional file (completion available)
- `unbak`: remove bak extension
- `unesc`: Ruby cgi unescape
- `up`: cd to a parent folder with fuzzy matching
- `urlenc`: url encode the passed string
- `watchthis`: Watch for changes in the current directory and execute command
- `xc`: Open Xcode with optional file (completion available)
- `yep`: echo "yep"
- `yn`: Simple pass/fail test for given command
- `zipup`: exports a clean copy of the current git repo (master) to a zip file

I'll update these every once in a while. If you're digging through and spot a problem, a stupid mistake, or something that could just plain be done better, please add an issue and let me know!
