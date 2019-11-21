function gtheirs -d "Resolve git conflicts with theirs"
  git st | grep -e '^U' | sed -e 's/^UU *//' | xargs git checkout --theirs
end