function abbrs --description 'Search abbreviations'
  abbr | cut -d' ' -f5- | grep -E (fallback $argv '^\w+')
end
