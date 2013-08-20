#!/usr/bin/env ruby
# Execute all other files and print results prettily.

require 'rubygems'
require 'date'
require 'net/http'
require 'open-uri'
require 'wuparty'
require 'fileutils'

require_relative 'parse_all'
require_relative 'scrape'

# Ideally, get rid of nil field...
Rows = ["nil",
        "profile_num", "first_name", "last_name", "phone", "email", "resume",
        "linkedin", "blog", "twitter", "github", "stackoverflow", 
        "coderwall", "hackernews", "teamtreehouse", "codeschool",
        "picture", "interests", "bio", "looking", "live", "other"]

# To be filled in via #scraper
Student_IDs = { }

# To be filled in and written to a file to generate the final pdf (#scraper)
Page_Titles = "cover.html\nindex.html\n"

def download(url, n, first, last, dir)

  ext = url.match(/(\w{2,})$/)

  File.open("#{dir}/#{first}#{last}.#{ext}", "w") do |saved_file|
    open(url, 'r') do |read_file|
      saved_file.write(read_file.read)
    end
  end

end

def parser
  
  if ARGV.length == 0

    print "Creating markdown files for profiles... "
    
    profile_page = Generator.new("markdown_p")
    print "Done.\nCreating markdown files for resumes... "

    resume_page = Generator.new("markdown_r")
    print "Done.\nCreating text files... "

    txt = Generator.new("txt")
    print "Done.\nDownloading image files... "

    img = Generator.new("img")
    print "Done.\nDownloading resume files... "

    resume_file = Generator.new("resume")
    print "Done.\nCompleted parsing and downloading.\n"

  elsif ARGV.length > 0

    option = ARGV[0]
    # Later, move this to bash script? And put it ahead of other processes?
    case option
    when "profile_pages"
      profile_page = Generator.new("markdown_p")
    when "resume_pages"
      resume_page = Generator.new("markdown_r")
    when "markdown_pages"
      profile_page = Generator.new("markdown_p")
      resume_page = Generator.new("markdown_r")
    when "text_files"
      txt = Generator.new("txt")
    when "images"
      img = Generator.new("img")
    when "resume_files"
      resume_file = Generator.new("resume")
    else
      print "Could not parse #{ARGV[0]}: "
      print "Invalid command line option given to parse script.\n"
      exit
    end

  end

end


scraper
parser
