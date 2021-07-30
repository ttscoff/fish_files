#!/usr/bin/env ruby
# encoding: utf-8

ARGV.each do |file|
  url = File.expand_path(file)
  if File.exists?(url)
    hooks = %x{osascript <<'APPLESCRIPT'
      tell application "Hook"
        set _mark to bookmark from URL "#{url}"
        set _hooks to bookmarks hooked to _mark
        set _out to {}
        repeat with _hook in _hooks
          set _out to _out & path of _hook
        end repeat
        set {astid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, "
"}
          set _output to _out as string
          set AppleScript's text item delimiters to astid
          return _output
      end tell
APPLESCRIPT}.strip

    if hooks.length > 0
      $stdout.puts "#{file} is hooked to:"
      $stdout.puts hooks.split("\n").map{|h| "- #{h}"}.join("\n")
    end
  end
end
