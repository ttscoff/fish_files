function license
  set -l base_url https://api.github.com/licenses
  set -l headers 'Accept: application/vnd.github.drax-preview+json'

  if test $argv[1]
    set -l license $argv[1]
    set -l res (curl --silent --header $headers $base_url/$license | jq .'body')
    echo -e $res | sed -e 's/^"//' -e 's/"$//'
  else
    set -l res (curl --silent --header $headers $base_url)
    echo "Available Licenses: "
    echo
    echo "$res" | jq .[].'key' | sed -e 's/^"//' -e 's/"$//'
  end
end
