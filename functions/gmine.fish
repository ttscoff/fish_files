function gmine -d "Resolve git conflicts with mine"
  git st | grep -e '^U' | sed -e 's/^UU *//' | xargs git checkout --ours
end