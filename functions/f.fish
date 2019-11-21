function f -d "Open directory in Finder"
  open -F (fallback $argv ".")
end