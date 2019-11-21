function gsearch -d 'grep git commit history'
  git log -g --grep="$argv"
end
