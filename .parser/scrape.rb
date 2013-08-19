#!/usr/bin/env ruby
# Scrape data from Wufoo survey.
# See https://help.github.com/articles/remove-sensitive-data !!!

require 'wuparty'
require 'fileutils'

ACCOUNT = 'flatironschool'
API_KEY = '2UDV-LOZ7-2TY9-SH7J'
FORM_ID = 'ruby-002-student-profile-survey'

def scraper

  names = []

  wufoo = WuParty.new(ACCOUNT, API_KEY)
  form = wufoo.form(FORM_ID)

  FileUtils.mv('bak/sps.txt', 'bak/sps.txt.bak')

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
    id = 1

    for student in names
      Student_IDs[student] = id
      id += 1
    end

    # Has the file closed?..
  end

#  sps.close # ^ ?

end
