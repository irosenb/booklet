#!/usr/bin/env ruby
# Parses tab-delimited text file of student profile survey results.

def parse_txt

  count = 0
  id = 1

  file = File.open("bak/sps.txt").each do |line|

    txt = "---\n"
    first_name = ""
    last_name = ""

    line.split("\t").each do |item|
      count += 1

      if count == 2
        first_name = "#{item}"

      elsif count == 3
        last_name = "#{item}"

      elsif count == 6 and "#{item}".include?("(")

        url = "#{item}".scan(/\(([^\)]+)\)/)[0][0]

        if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
          ext = url.match(/(\w{2,})$/)
          item = "#{first_name}#{last_name}.#{ext}"
        end

      elsif count == 9 
        if item.chars.to_a[0] == '@'
          item = item[1..-1]
        end

      elsif count == 16 and "#{item}".include?("(")

        url = "#{item}".scan(/\(([^\)]+)\)/)[0][0]

        if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
          ext = url.match(/(\w{2,})$/) # Probably don't need inner ( )s
          item = "#{first_name}#{last_name}.#{ext}"
        end

      elsif count == 18
        item = item.gsub( /(\.)(\w{2,})/, "\\1\n\n\\2" )
        item = "\"#{item}\""
      end

      if count < 22
        txt << "#{Rows[count]}: #{item}\n"
      end
    end

    txt << "---"

    student = File.open("txt/#{first_name}#{last_name}.txt", "w")

    count = 0
    id += 1

    student << txt
    student.close

  end
end
