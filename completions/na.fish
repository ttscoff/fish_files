function __fish_na_needs_command
  # Figure out if the current invocation already has a command.

  set -l opts a-add add_at= color cwd_as= d-depth= debug ext= f-file= help include_ext n-note p-priority= pager f-recurse t-na_tag= template= version
  set cmd (commandline -opc)
  set -e cmd[1]
  argparse -s $opts -- $cmd 2>/dev/null
  or return 0
  # These flags function as commands, effectively.
  if set -q argv[1]
    # Also print the command, so this can be used to figure out what it is.
    echo $argv[1]
    return 1
  end
  return 0
end

function __fish_na_using_command
  set -l cmd (__fish_na_needs_command)
  test -z "$cmd"
  and return 1
  contains -- $cmd $argv
  and return 0
end

function __fish_na_subcommands
  na help -c
end

complete -c na -f
complete -xc na -n '__fish_na_needs_command' -a '(__fish_na_subcommands)'

complete -xc na -n '__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from (na help -c)' -a "(na help -c)"

complete -xc na -n '__fish_na_needs_command' -a 'add' -d Add\ a\ new\ next\ action
complete -xc na -n '__fish_na_needs_command' -a 'archive' -d Mark\ an\ action\ as\ @done\ and\ archive
complete -xc na -n '__fish_na_needs_command' -a 'changes changelog' -d Display\ the\ changelog
complete -xc na -n '__fish_na_needs_command' -a 'complete finish' -d Find\ and\ mark\ an\ action\ as\ @done
complete -xc na -n '__fish_na_needs_command' -a 'completed finished' -d Display\ completed\ actions
complete -xc na -n '__fish_na_needs_command' -a 'edit' -d Edit\ an\ existing\ action
complete -xc na -n '__fish_na_needs_command' -a 'find grep search' -d Find\ actions\ matching\ a\ search\ pattern
complete -xc na -n '__fish_na_needs_command' -a 'help' -d Shows\ a\ list\ of\ commands\ or\ help\ for\ one\ command
complete -xc na -n '__fish_na_needs_command' -a 'init create' -d Create\ a\ new\ todo\ file\ in\ the\ current\ directory
complete -xc na -n '__fish_na_needs_command' -a 'initconfig' -d Initialize\ the\ config\ file\ using\ current\ global\ options
complete -xc na -n '__fish_na_needs_command' -a 'move' -d Move\ an\ existing\ action\ to\ a\ different\ section
complete -xc na -n '__fish_na_needs_command' -a 'next show' -d Show\ next\ actions
complete -xc na -n '__fish_na_needs_command' -a 'open' -d Open\ a\ todo\ file\ in\ the\ default\ editor
complete -xc na -n '__fish_na_needs_command' -a 'projects' -d Show\ list\ of\ projects\ for\ a\ file
complete -xc na -n '__fish_na_needs_command' -a 'prompt' -d Show\ or\ install\ prompt\ hooks\ for\ the\ current\ shell
complete -xc na -n '__fish_na_needs_command' -a 'restore unfinish' -d Find\ and\ remove\ @done\ tag\ from\ an\ action
complete -xc na -n '__fish_na_needs_command' -a 'saved' -d Execute\ a\ saved\ search
complete -xc na -n '__fish_na_needs_command' -a 'tag' -d Add\ tags\ to\ matching\ action\(s\)
complete -xc na -n '__fish_na_needs_command' -a 'tagged' -d Find\ actions\ matching\ a\ tag
complete -xc na -n '__fish_na_needs_command' -a 'todos' -d Show\ list\ of\ known\ todo\ files
complete -xc na -n '__fish_na_needs_command' -a 'undo' -d Undo\ the\ last\ change
complete -xc na -n '__fish_na_needs_command' -a 'update' -d Update\ an\ existing\ action
complete -c na -F -n '__fish_na_using_command undo'
