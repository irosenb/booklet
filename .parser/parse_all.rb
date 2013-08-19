#!/usr/bin/env ruby
# Parses tab-delimited text file of student profile survey results.
# Goal for this file: combine all other parse methods and execute
# require functionality by passing in a type argument.
#
# TODO:
# - Modularize (use `extract method` in several places in #parse_all).
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

      # TODO: If there are newlines in the interests, parse by newlines.
      # If there are only commas, parse by commas.

      # TODO: Make Wufoo able to feed interests via separate fields...
      # people fill them out / separate their interests too arbitrarily.

    end
    item
  end

  def get_interests(item)

    item = "\n- #{item}"

    if item =~ /(\\r\\n)+$/
      item = item.gsub( /(\\r\\n)+$/, "" )
      # Strip returns from end of string
    end

    if item =~ /\\r\\n/

      item = item.gsub( /(\\r\\n)+/, "\n- " )
      item = item.gsub( /(- - )/, "- ") # ???

    else
      if item =~ /,/

        item = item.gsub( /(\,)[ ]*(\w{2,})/, "\n- \\2" )

      end
    end

    # Capitalize
    item = item.gsub(/^\W*(\w)/){ |m| 
      m.sub($1, $1.upcase) }

    # Wrap each line in quotes
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

  def add_item_to_text(item)
    @txt << "#{Rows[@count]}: #{item}\n"
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
          when 21
            item = get_other(item)
          end

        end

        if @count == 2
          add_item_to_text(@first_name)
          
        elsif @count == 3
          add_item_to_text(@last_name)

        elsif @count != @count_dl

          if @count < 22
            add_item_to_text(item)
          end

        end

      end

      @count = 0
      @id += 1

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
