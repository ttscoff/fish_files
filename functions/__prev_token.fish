function __prev_token
  set -l buffer (commandline -bo)
  commandline -a " "$buffer[-1]
  commandline -f end-of-line
end
