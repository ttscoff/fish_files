function __re_extension -d "remove extension from word under/before cursor"
  commandline -f forward-word
  commandline -f backward-word
  set -l token (commandline -t)
  set token (echo "$token" | sed -E 's/\.[^.]*\.?$/./')
  commandline -t ""
  commandline -i $token
end
