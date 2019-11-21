# Brett's Fish Files

A collection of configuration files and functions for the Fish shell. These would be installed in `~/.config/fish/`, though I don't recommend overwriting your current setup wholesale. Pick and choose, use this repo as examples for your own exploration.

## The parts

__bash_scripts__: some utilities that were too much trouble to port from Bash and work just as well run with hashbangs. They just need to be in the $PATH.

__completions__: various completion configurations for custom commands.

__custom__: some files I source at login (from `config.fish`), mostly shared functions I prefer to have in memory (as opposed to autoloaded), and some aliases I just haven't gotten around to turning into autoloaded functions yet.

__functions__: the motherload. All of my favorite commands (and some experimental ones). Most have a description on the function declaration, so you can see it in source or by running the `describe` command that you'll find in this folder (which essentially runs `functions -Dv`, but prettier).

I'll update these every once in a while. If you're digging through and spot a problem, a stupid mistake, or something that could just plain be done better, please add an issue and let me know!
