#!/usr/bin/env ruby
# Parses tab-delimited text file of student profile survey results.
# Goal for this file: combine all other parse methods and execute
# require functionality by passing in a type argument.
#
# TODO:
# - Clean up.
# - Change name of this file to parse.rb and name of parse.rb to generate.rb?

def valid_url(url)
  response = Net::HTTP.get_response(URI.parse(url))
  response.code.to_i == 200
end

def human_readable(type)
  case type
  when "txt"
    type = "text page"
  when "img"
    type = "image file"
  when "resume"
    type = "resume file"
  when "markdown_r"
    type = "resume page"
  when "markdown_p"
    type = "profile page"
  end

  type

end


class Generator

  attr_accessor :count, :count_dl, :type, :txt, :item, :id, :first_name, \
  :last_name
  # Not sure about :id or :item

  def initialize(type)
    @type = type
    @count = 0
    @id = 1

    parse_all
  end


  def get_first_name(item)
    @first_name = item
  end

  def get_last_name(item)
    @last_name = item
  end

  def get_phone_num(item)
    item = item.gsub(/\A(\d{3,4})(\d{3})(\d{4})\Z/, "\\1-\\2-\\3")
  end

  def get_image(item, file_path) # TODO: RENAME!

    if item.include?("(")

      url = item.scan(/\(([^\)]+)\)/)[0][0]

      if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
        @txt << "#{url}\n"
        dir = file_path.scan(/^(\w+)\//)[0][0]
        
        if valid_url(url)
          download(url, @id, @first_name, @last_name, dir)

          if @type == "img"
            ext = url.match(/(\w{2,})$/)
            FileUtils.cp("img/#{@first_name}#{@last_name}.#{ext}",
                         "../img/student/")
          end
        end

      end
    end
    # item = ???
  end

  def get_resume(item)

    if item.include?("(")

      url = item.scan(/\(([^\)]+)\)/)[0][0]

      if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
        ext = url.match(/(\w{2,})$/)
        item = "#{@first_name}#{@last_name}.#{ext}"
      end

    end
    item
  end

  def get_twitter(item)

    if item.chars.to_a[0] == '@'
      item = item[1..-1]
    end

    item
  end

  def get_picture(item)

    if item.include?("(")

      url = item.scan(/\(([^\)]+)\)/)[0][0]

      if (! (url.match(/\/$/)) ) and ( url.match(/\w+\./) )
        ext = url.match(/(\w{2,})$/) # Probably don't need inner ( )s
        item = "#{@first_name}#{@last_name}.#{ext}"
      end

      # TODO: Fix code for items 17 and 18 so that the quotes more
      # elegantly are wrapped around the array elements.

      # TODO: Make Wufoo able to feed interests via separate fields...
      # people fill them out / separate their interests too arbitrarily. (!?)

    end
    item
  end

  def get_interests(item)

    item = "\n- #{item}"

    if item =~ /(\\r\\n)+$/
      item = item.gsub( /(\\r\\n)+$/, "" )
    end

    if item =~ /\\r\\n/

      item = item.gsub( /(\\r\\n)+/, "\n- " )
      item = item.gsub( /(- - )/, "- ") # ???

    else

      if item =~ /,/
        item = item.gsub( /(\,)[ ]*(\w{2,})/, "\n- \\2" )
      end

    end

    item = item.gsub(/^\W*(\w)/) { |m| m.sub($1, $1.upcase) }

    # NOTE: This could lead to problems if people do not input
    # characters of type [\w. (etc...) \/-]
    item = item.gsub(/(- )*([\w., \/\-\(\)\:\"\\\&\']+)[\n|$]*/,
                     "- \"\\2\"\n")

    # Can we combine the above regex into a single, more elegant
    # capture and substitution?
    item
  end

  def get_bio(item)
    item = "\n- \"#{item}"
    item = item.gsub( /(\.)[ ]*(\\r\\n)+(\w{2,})/, "\\1\"\n- \"\\3" )
    item = "#{item}\""
  end

  def get_other(item)
    item = "\"#{item}\""
  end

  def get_tech(item)
    matches = item.match /\[([\w\d -.,!?']*)\]/
    if matches
      name = matches.captures[0]
      description = matches.captures[1]
      item = "\n  name: \"#{name}\"\n  description: \"#{description}\""
      item << "\n  notes:\n    - "
      len = matches.length
      puts "---------------------"
      puts(len)
      puts "---------------------"
      if len > 2
        for match in (matches.captures[2]...matches.captures[len])
          print(match)
        end
      end

    else
      item = ""
    end
    
    item
  end

  def get_edu(item)
    matches = item.match /\[([\w\d -.,!?']*)\]/
    if matches
      name = matches.captures[0]
      date = matches.captures[1]

      item = "\n  name: \"#{name}\"\n  date: \"#{date}\""
      item << "\n  notes:\n    - "
      len = matches.length
      puts "---------------------"
      puts(len)
      puts "---------------------"
      if len > 2
        for match in (matches.captures[2]...matches.captures[len])
          print(match)
        end
      end
#      print item
    else
      item = ""
    end

    item
  end

  def get_job(item)
#    print item
    matches = item.scan(/\[([\w\d -.,!?']*)\]/)
    print matches
    if matches
      company = matches.captures[0][0]
      location = matches.captures[1]
      position = matches.captures[2]
      dates = matches.captures[3]

      item = "\n  company: \"#{company}\""
      item << "\n  location: \"#{location}\""
      item << "\n  position: \"#{position}\"\n  dates: \"#{dates}\""
      item << "\n  duties:\n    - "
      len = matches.size
      puts "---------------------"
      puts(len)
      puts "---------------------"
      if len > 4
        for match in (matches.captures[4]...matches.captures[len])
          print(match)
        end
      end
#      print item
    else
      item = ""
    end

    item
  end

  def add_item_to_text(item, student_id = false)
    if !(student_id)
      @txt << "#{Rows[@count]}: #{item}\n"
    else
      @txt << "profile_num: #{item}\n"
    end
  end

  def parse_all

    file = File.open("bak/sps.txt").each do |line|

      case @type
      when "img"
        @count_dl = 16
        file_path = "img/images.txt"
      when "resume"
        @count_dl = 6
        file_path = "resume/resumes.txt"
      when "txt"
        @count_dl = -1
        @txt = "---\n"
      when "markdown_p"
        @count_dl = -1
        @txt = "---\nlayout: post\n"
      when "markdown_r"
        @count_dl = -1
        @txt = "---\nlayout: resume\n"
      else
        print "\nInvalid type given to parse_all method.\n"
        return nil
      end

      @txt ||= ""
      @first_name = ""
      @last_name = ""

      FileUtils.touch(file_path) if
        (@type == "img") or (@type == "resume") # ???

      dl_file = File.open(file_path, "w") if
        (@type == "img") or (@type == "resume")

      line.split("\t").each do |item|
        @count += 1

        # Reconsider scope in this block with passing along "item"...
        # Reconsider cases 2 and 3 for @count (first and last name)

        case @count
        when 2
          @first_name = get_first_name(item)
        when 3
          @last_name = get_last_name(item)
          @id = Student_IDs[[@first_name, @last_name]]
        when 4
          item = get_phone_num(item)
        when @count_dl
          item = get_image(item, file_path)
        end

        if (@type == "txt") or (@type.include?("markdown"))

          case @count
          when 6
            item = get_resume(item)
          when 9
            item = get_twitter(item)
          when 16
            item = get_picture(item) # ???
          when 17
            item = get_interests(item)
          when 18
            item = get_bio(item)
          when 33
            item = get_other(item)
          else

            if (@type != "markdown_r")
              item = "\"#{item}\""
            else # is resume

              case @count

              # when 19
              #   item = "technical_experience:\n"
              #   item << get_tech(item)
              when 19, 20, 21, 22
                item = get_tech(item)

              # when 23
              #   item = "education:\n"
              #   item << get_edu(item)
              when 23, 24, 25, 26
                item = get_edu(item)

              # when 27
              #   item = "employment_history:\n"
              #   item << get_job(item)
              when 27, 28, 29, 30
                item = get_job(item)
              end

            end

          end
        end

        
        if @count == 2
          add_item_to_text(@first_name)
          
        elsif @count == 3
          add_item_to_text(@last_name)
          add_item_to_text(@id, true)

        elsif @count != @count_dl

          if (@count > 1) and (@count < 34)
            add_item_to_text(item)
          end

        end

      end

      @count = 0

      if (@type == "txt") or (@type.include?("markdown"))
        @txt << "---"
        md_name = ""

        if @type == "txt"
          student = File.open("txt/#{@first_name}#{@last_name}.txt", "w")

        elsif @type == "markdown_p"
          md_name = "#{Date.today}-#{@first_name}#{@last_name}_profile.md"
          student = File.open("markdown/#{md_name}", "w")

        elsif @type == "markdown_r"
          md_name = "#{Date.today}-#{@first_name}#{@last_name}_resume.md"
          student = File.open("markdown/#{md_name}", "w")

        end

        student << @txt
        student.close

        print("Finished #{human_readable(@type)} for #{@first_name} #{@last_name}\n")

      end

      if @type.include?("markdown")
        FileUtils.cp("markdown/#{md_name}", "../_posts/#{md_name}")
      end

    end
  end
end
