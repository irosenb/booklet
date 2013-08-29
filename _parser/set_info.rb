#!/usr/bin/env ruby
# Set Wufoo API key and form name information.

def set_wufoo(key, form)
  File.open("wufoo_info.txt", "w") do |file|
    file.write("#{key}\n#{form}")
  end
end

if ARGV.length > 0
  set_wufoo(ARGV[0], ARGV[1])
end
