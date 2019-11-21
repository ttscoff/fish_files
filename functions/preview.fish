function preview -d "Preview text files using fzf and bat"
  fzf --preview 'bat --color "always" {}'
end

