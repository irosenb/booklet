#!/usr/bin/env ruby
# Scrape data from Wufoo survey.
# See https://help.github.com/articles/remove-sensitive-data !!!

require 'wuparty'
require 'fileutils'

ACCOUNT = 'flatironschool'

def get_api_key
  key = { }

  count = 0
  File.open("wufoo_info.txt", "r").each_line do |line|
    line = line.gsub(/\n/, "")
    key[count] = line
    count += 1
  end

  key
end

def scraper

  names = []
  wufoo_info = get_api_key
  api_key = wufoo_info[0]
  form_id = wufoo_info[1]

  if api_key == ""
    print "\nNo API key set. Please run `./parse.sh api [key]`.\n"
    return 0
  end
  # And other error-catching for other fields and other possible errors.
  # (check response from Wufoo before?)
  wufoo = WuParty.new(ACCOUNT, api_key)
  form = wufoo.form(form_id)

  if File.exist?('bak/sps.txt')
    FileUtils.mv('bak/sps.txt', 'bak/sps.txt.bak')
  end

  File.open("bak/sps.txt", "w") do |sps|

    form.entries(:limit => 1000).each do |student|
      count = 0
      txt = ""
      name = []

      student.each do |field|

        count += 1
        if count == 2 or count == 3
          name << field[1]
        end

        txt << ("%s\t" % (field[1].inspect)[1..-2]) if count < 22

      end

      names << name
      txt << "\n"
      sps.write(txt)

    end

    names = names.uniq
    names.sort!

    # Refactor this bit #
    for student_name in names
      item = ""

      for part in student_name
        item << part
      end

      Page_Titles << "#{item}_profile/index.html\n#{item}_resume/index.html\n"
    end
    #####################

    File.open("pdf_page_names.txt", "w") { |file|
      file.write(Page_Titles)
    }

    id = 1

    for student in names
      Student_IDs[student] = id
      id += 1
    end

    # Has the file closed?..
  end

#  sps.close # ^ ?

end
