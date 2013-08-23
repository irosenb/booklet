#!/usr/bin/env ruby
# Execute all other files and print results prettily.

require 'rubygems'
require 'bundler/setup'
require 'date'
require 'net/http'
require 'open-uri'
require 'wuparty'
require 'fileutils'

require_relative 'parse_all'
require_relative 'scrape'
require_relative 'set_info'

Student_IDs = { }
Page_Titles = "cover.html\nblank.html\nindex.html\nblank.html\n"
Rows = [ "nil",
         "profile_num", "first_name", "last_name", "phone", "email", "resume",
         "linkedin", "blog", "twitter", "github", "stackoverflow", 
         "coderwall", "hackernews", "teamtreehouse", "codeschool",
         "picture", "interests", "bio", "technical_experience:\n- project",
         "- project", "- project", "- project", "education:\n- school",
         "- school", "- school", "- school", "employment_history:\n- job",
         "- job", "- job", "- job", "looking", "live", "other" ]

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
    when "info"

      if ARGV.length > 1
        set_wufoo(ARGV[0], ARGV[1])
      else
        print("\nPlease input an API key.\n")
      end

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

    when "generate"
      profile_page = Generator.new("markdown_p")
      resume_page = Generator.new("markdown_r")

      print "Generating pdf of booklet...\n"
      `./make_pdf.sh`
      print "\nFinished generating booklet. Downloading images..."
      img = Generator.new("img")

      `./make_pdf.sh`
      print "\nFinished regenerating images.\n"

    else
      print "Could not parse #{ARGV[0]}: "
      print "Invalid command line option given to parse script.\n"
      exit
    end

  end

end

# if ARGV.length > 0
#   if ARGV[1] == "api"
#     set_wufoo(ARGV[1])
#   end
#   # Or run `ruby set_api.rb ARGV[n]`
# end

if (File.exist?("wufoo_info.txt"))
  scraper
  parser
else
  print "\nMust create an API key first by running `./parse.sh api [key]`.\n"
  return 0
end
