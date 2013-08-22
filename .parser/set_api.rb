#!/usr/bin/env ruby
# Set API key.

def set_api_key(key)
  File.open("api_key.txt", "w") do |file|
    file.write(key)
  end
end

if ARGV.length > 0
  set_api_key(ARGV[0])
end
