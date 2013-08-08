#!/usr/bin/env ruby
# Parses tab-delimited text file of student profile survey results.
# Goal for this file: combine all other parse methods and execute
# require functionality by passing in a type argument.

def parse_all(type)

  case type
  when "resume"
    count_dl = 16
    file_path = "img/images.txt"
  when "img"
    count_dl = 6
    file_path = "resume/resumes.txt"
  else
    print "\nInvalid type fed to parse_all method.\n"
    return nil
  end

  count = 0
  id = 1

  txt = ""
  dl_file = File.open(file_path, "w")

  file = File.open("bak/sps.txt").each do |line|

    first_name = ""
    last_name = ""

    line.split("\t").each do |item|
      count += 1
      if count == 2
        first_name = "#{item}"

      elsif count == 3
        last_name = "#{item}"

      elsif count == count_dl and "#{item}".include?("(")

        url = "#{item}".scan(/\(([^\)]+)\)/)[0][0]

        if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
          txt << "#{url}\n"
          dir = file_path.scan(/^(\w+)(\/?)/)
          print(dir)
          download("#{url}", id, first_name, last_name, "img")
        end

      end

    end

    count = 0
    id += 1
    
  end

  dl_file << txt
  dl_file.close

end
