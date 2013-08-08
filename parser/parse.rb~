#!/usr/bin/env ruby
# Execute all other files and print results prettily.

require 'rubygems'
require 'date'
#require 'curb' # ?
require 'net/http'
require 'open-uri'
require 'wuparty'

require_relative 'parse_all'
require_relative 'markdown/parse_md'
require_relative 'txt/parse_txt'
require_relative 'img/parse_img'
require_relative 'resume/parse_resume'

# Ideally get rid of this first "nil" field...
Rows = ["nil",
        "profile_num", "first_name", "last_name", "phone", "email", "resume",
        "linkedin", "blog", "twitter", "github", "stackoverflow", 
        "coderwall", "hackernews", "teamtreehouse", "codeschool",
        "picture", "interests", "bio", "looking", "live", "other"]

def download(url, n, first, last, dir)

  ext = url.match(/(\w{2,})$/)

  File.open("#{dir}/#{first}#{last}.#{ext}", "w") do |saved_file|
    open(url, 'r') do |read_file|
      saved_file.write(read_file.read)
    end
  end

end

def parser
  print "Creating markdown files... "
  parse_all("markdown")
  print "Done.\nCreating text files... "
  parse_all("txt")
  print "Done.\nDownloading resume files... "
  parse_all("resume")
  print "Done.\nDownloading image files... "
  parse_all("img")

  print "\nCompleted parsing and downloading.\n"
end

parser
