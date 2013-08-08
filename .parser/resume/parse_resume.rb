#!/usr/bin/env ruby
# Grabs student profile resumes.

def parse_resume

  count = 0
  id = 1

  txt = ""
  resume_file = File.open("resume/resumes.txt", "w")

  file = File.open("bak/sps.txt").each do |line|

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
          txt << "#{url}\n"
          download("#{url}", id, first_name, last_name, "resume")
        end

      end

    end

    count = 0
    id += 1
    
  end

  resume_file << txt
  resume_file.close

end
