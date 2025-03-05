#!/usr/bin/env ruby
# frozen_string_literal: true

##
## String helpers
##
class ::String
  ##
  ## Pluralize a string based on quantity
  ##
  ## @param      number  [Integer] the quantity of the
  ##                     object the string represents
  ##
  def to_p(number)
    number == 1 ? self : "#{self}s"
  end

  # Regular expression that is used to scan for ANSI-sequences while
  # uncoloring strings.
  COLORED_REGEXP = /\e\[(?:(?:[349]|10)[0-7]|[0-9])?m/.freeze

  # Returns an uncolored version of the string, that is all
  # ANSI-sequences are stripped from the string.
  def uncolor
    gsub(COLORED_REGEXP, '')
  end
end

##
## Number helpers
##
class ::Numeric
  ##
  ## Format human readable time from seconds
  ##
  ## @param      seconds  [Integer] Seconds
  ##
  def format_time(human: false)
    return [0, 0, 0] if nil?

    seconds = dup.to_i
    minutes = (seconds / 60).to_i
    hours = (minutes / 60).to_i
    if human
      minutes = (minutes % 60).to_i
      [0, hours, minutes]
    else
      days = (hours / 24).to_i
      hours = (hours % 24).to_i
      minutes = (minutes % 60).to_i
      [days, hours, minutes]
    end
  end

  ##
  ## Format seconds as natural language time string
  ##
  ## @param      format  [Symbol] The format to output
  ##                     (:dhm, :hm, :m, :clock, :natural)
  ##
  def to_human(format: :dhm)
    format_time(human: true).time_string(format: format)
  end
end

##
## Array helpers
##
class ::Array
  def to_years
    d, h, m = self

    if d.zero? && h > 24
      d = (h / 24).floor
      h = h % 24
    end

    if d > 365
      y = (d / 365).floor
      d = d % 365
    else
      y = 0
    end

    [y, d, h, m]
  end

  def to_natural
    y, d, h, m = to_years
    human = []
    human.push(format('%<y>d %<s>s', y: y, s: 'year'.to_p(y))) if y.positive?
    human.push(format('%<d>d %<s>s', d: d, s: 'day'.to_p(d))) if d.positive?
    human.push(format('%<h>d %<s>s', h: h, s: 'hour'.to_p(h))) if h.positive?
    human.push(format('%<m>d %<s>s', m: m, s: 'minute'.to_p(m))) if m.positive?
    human
  end

  def to_abbr(years: false, separator: '')
    if years
      y, d, h, m = to_years
    else
      y = 0
      d, h, m = self

      if d.zero? && h > 24
        d = (h / 24).floor
        h = h % 24
      end
    end

    output = []
    output.push(format('%<y>dy', y: y)) if y.positive?
    output.push(format('%<d>dd', d: d)) if d.positive?
    output.push(format('%<h>dh', h: h)) if h.positive?
    output.push(format('%<m>dm', m: m)) if m.positive?
    output.join(separator)
  end

  ##
  ## Format [d, h, m] as string
  ##
  ## @accept     [Array] Array of [days, hours, minutes]
  ##
  ## @param      format  [Symbol] The format, :dhm, :hm,
  ##                     :m, :clock, :natural
  ## @return     [String] formatted string
  ##
  def time_string(format: :dhm)
    raise 'Invalid array, must be [d,h,m]' unless count == 3

    d, h, m = self
    case format
    when :clock
      if d.zero? && h > 24
        d = (h / 24).floor
        h = h % 24
      end
      format('%<d>02d:%<h>02d:%<m>02d', d: d, h: h, m: m)
    when :hmclock
      h += d * 24 if d.positive?
      format('%<h>02d:%<m>02d', h: h, m: m)
    when :ydhm
      to_abbr(years: true, separator: ' ')
    when :dhm
      to_abbr(years: false, separator: ' ')
    when :hm
      h += d * 24 if d.positive?
      format('%<h>dh %<m>02dm', h: h, m: m)
    when :m
      h += d * 24 if d.positive?
      m += h * 60 if h.positive?
      format('%<m> 4dm', m: m)
    when :tight
      to_abbr(years: true, separator: '')
    when :natural
      to_natural.join(', ')
    when :speech
      human = to_natural
      last = human.pop
      case human.count
      when 0
        last
      when 1
        "#{human[0]} and #{last}"
      else
        human.join(', ') + ", and #{last}"
      end
    end
  end
end

if ARGV.count == 3
  start = ARGV[0].uncolor.to_i
  finish = ARGV[1].uncolor.to_i
  output_format = ARGV[2]
  result = (finish - start).to_human(format: output_format.to_sym)
  puts result
elsif ARGV.count <= 2 && ARGV.count.positive?
  output_format = ARGV[1] || 'ydhm'
  result = ARGV[0].uncolor.to_i.to_human(format: output_format.to_sym)
  puts result
else
  puts "Usage: #{File.basename(__FILE__)} SECONDS [FORMAT]"
  puts "Formats: clock hmclock ydhm dhm hm m tight natural speech"
  Process.exit 1
end
