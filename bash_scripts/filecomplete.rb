#!/usr/bin/env ruby

# filecomplete.rb txt [partial]
ext = ARGV[0]
input = ARGV[1]

def find_dir(string)

  input = string.dup

  if input.nil? || input.strip.empty?
    return {:dir => Dir.pwd, :file => '*'}
  end

  input = File.expand_path(input)

  if File.exists?(input)
    if File.directory?(input)
      return {:dir => input, :file => '*'}
    else
      return {:dir => File.dirname(input), :file => File.basename(input)}
    end
  else
    dirname = File.dirname(input)
    if File.directory?(dirname)
      return {:dir => dirname, :file => "*#{File.basename(input)}*"}
    else
      return nil
    end
  end
end

def glob_dirs_and_ext(dir, partial, ext)
  exts = ext.split(/ +/)
  files = Dir.glob(File.join(dir, partial))
  directories = files.select {|file|
    File.directory?(file)
  }.delete_if {|file|
    file == Dir.pwd
  }.map {|file|
    "#{file}/\tDirectory"
  }

  matches = files.select {|file|
    file =~ /\.(#{exts.join('|')})$/
  }.map {|file|
    "#{file}\t#{File.extname(file)} file"
  }
  matches.concat(directories.sort)
end


dir = find_dir(input)

if dir
  results = glob_dirs_and_ext(dir[:dir], dir[:file], ext)
  puts results.map {|res|
    res.sub(/#{Regexp.escape(Dir.pwd)}\/(.+)/,'\1')
  }.join("\n")
else
  puts ""
end
