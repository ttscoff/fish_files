function gg -d 'Commit pending changes and quote all args as message'
  git commit -v -a -m "$argv"
end
