#!/usr/bin/env ruby
# Parses tab-delimited text file of student profile survey results.
# Goal for this file: combine all other parse methods and execute
# require functionality by passing in a type argument.

# This file needs to be cleaned up. Also, parsing can probably be combined,
# rather than being done four times (once for each type).

# TODO:
# Modularize (use `extract method` in several places in #parse_all)

def valid_url(url)
  res = Net::HTTP.get_response(URI.parse(url))
  res.code.to_i == 200
end

def get_first_name(data)
  if data[count ]acce== 2
    first_name = "#{item}"
  end
end

def get_last_name(data)
  if count == 2
    last_name = "#{item}"
  end
end

def get_phone_num(data)
  if count == 4
    item = item.gsub(/\A(\d{3,4})(\d{3})(\d{4})\Z/, "\\1-\\2-\\3")
  end
end

def get_bio(data)

  if count == count_dl and "#{item}".include?("(")

    url = "#{item}".scan(/\(([^\)]+)\)/)[0][0]

    if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
      txt << "#{url}\n"
      dir = file_path.scan(/^(\w+)\//)[0][0]
      
      if valid_url(url)
        download("#{url}", id, first_name, last_name, dir)

        if type == "img"
          ext = url.match(/(\w{2,})$/)
          FileUtils.cp("img/#{first_name}#{last_name}.#{ext}",
                       "../img/student/")
        end
      end

    end
  end

end

def parse_all(type)

  count = 0
  id = 1

  file = File.open("bak/sps.txt").each do |line|

    case type
    when "img"
      count_dl = 16
      file_path = "img/images.txt"
    when "resume"
      count_dl = 6
      file_path = "resume/resumes.txt"
    when "txt"
      count_dl = -1
      txt = "---\n"
    when "markdown_p"
      count_dl = -1
      txt = "---\nlayout: post\n"
    when "markdown_r"
      count_dl = -1
      txt = "---\nlayout: resume\n"
    else
      print "\nInvalid type given to parse_all method.\n"
      return nil
    end

    txt ||= ""
    first_name = ""
    last_name = ""

    FileUtils.touch(file_path) if (type == "img" or type == "resume")
    dl_file = File.open(file_path, "w") if (type == "img" or type == "resume")

    line.split("\t").each do |item|
      count += 1

      data = { :item => item, :count => count, :count_dl => count_dl,
        :type => type }

      first_name = get_first_name(data) #2
      last_name = get_last_name(data) #3
      item = get_phone_num(data) #4
      item = get_image(data) #count_dl
      item = get_resume(data) #6
      item = get_twitter(data) #9
      # number 16???
      item = get_interests(data) #17
      item = get_bio(data) #18
      item = get_other(data) #21

      if (type == "txt" or type.include?("markdown"))
        if count == 6 and "#{item}".include?("(")

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

          # TODO: Fix code for items 17 and 18 so that the quotes more
          # elegantly are wrapped around the array elements.

          # TODO: If there are newlines in the interests, parse by newlines.
          # If there are only commas, parse by commas.

          # TODO: Make Wufoo able to feed interests via separate fields...
          # people fill them out / separate their interests too arbitrarily.

        elsif count == 17

          item = "\n- #{item}"
#          print(item)
          if item =~ /\\r\\n/
            item = item.gsub( /(\\r\\n)+/, "\n" )
          end
#          else
            if item =~ /,/
              item = item.gsub( /(\,)[ ]*(\w{2,})/, "\n- \\2" )
            end
#          end

          # Capitalize
          item = item.gsub(/^\W*(\w)/){ |m| 
                           m.sub($1, $1.upcase) }

          # Wrap each line in quotes
          # NOTE: This could lead to problems if people do not input
          # characters of type [\w. \/-]
          item = item.gsub(/(- )*([\w. \/\-\(\)\:\"\\\&\']+)[\n|$]*/,
                           "- \"\\2\"\n")

          # Can we combine the above regex into a single, more elegant
          # capture and substitution?
          item = "#{item}"
          
        elsif count == 18
          item = "\n- \"#{item}"
          item = item.gsub( /(\.)[ ]*(\\r\\n)+(\w{2,})/, "\\1\"\n- \"\\3" )
#          item = item.gsub(/(- )+([\w. -]+)[\n|$]*/, "- \"\\2\"\n")
          item = "#{item}\""

        elsif count == 21
          item = "\"#{item}\""

        end

        if count < 22
          txt << "#{Rows[count]}: #{item}\n"
          #          puts txt
        end
      end

    end

    count = 0
    id += 1

    if (type == "txt" or type.include?("markdown"))
      txt << "---"
      md_name = ""

      if type == "txt"
        student = File.open("txt/#{first_name}#{last_name}.txt", "w")

      elsif type == "markdown_p"
        md_name = "#{Date.today}-#{first_name}#{last_name}_profile.md"
        student = File.open("markdown/#{md_name}", "w")

      elsif type == "markdown_r"
        md_name = "#{Date.today}-#{first_name}#{last_name}_resume.md"
        student = File.open("markdown/#{md_name}", "w")

      end

      count = 0
      id += 1

      student << txt
      student.close

      if type.include?("markdown")
        FileUtils.cp("markdown/#{md_name}",
                     "../_posts/#{md_name}")
      end
    end
  end
end