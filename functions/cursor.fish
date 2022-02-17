function cursor --description 'Show or hide the terminal cursor'
  if test (count $argv) -gt 1
    warn "Usage: `cursor [show|hide]`"
    return 1
  end

  switch $argv[1]
    case '-h'
      warn "Usage: `cursor [show|hide]`"
      return 1
    case 'h*'
      warn "Cursor hidden. Use `cursor show` to restore."
      tput civis
    case '*'
      tput cnorm
  end
end
