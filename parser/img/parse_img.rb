#!/usr/bin/env ruby
# Grabs student profile images.
# http://stackoverflow.com/a/10681625/2630972 !!! for getting curb working

def parse_img  

  count = 0
  id = 1

  txt = ""
  image_file = File.open("img/images.txt", "w")

  file = File.open("bak/sps.txt").each do |line|

    first_name = ""
    last_name = ""

    line.split("\t").each do |item|
      count += 1
      if count == 2
        first_name = "#{item}"

      elsif count == 3
        last_name = "#{item}"

      elsif count == 16 and "#{item}".include?("(")

        url = "#{item}".scan(/\(([^\)]+)\)/)[0][0]

        if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
          txt << "#{url}\n"
          download("#{url}", id, first_name, last_name, "img")
        end

      end

    end

    count = 0
    id += 1
    
  end

  image_file << txt
  image_file.close

end
