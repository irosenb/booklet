#!/usr/bin/env ruby
# Parse tab-delimited text file of student profile survey results

rows = {
  1 => "id",
  2 => "first_name",
  3 => "last_name",
  4 => "phone",
  5 => "email",
  6 => "resume",
  7 => "linkedin",
  8 => "blog",
  9 => "twitter",
  10 => "github",
  11 => "stackoverflow",
  12 => "coderwall",
  13 => "hackernews",
  14 => "teamtreehouse",
  15 => "codeschool",
  16 => "picture",
  17 => "interests",
  18 => "bio",
  19 => "looking",
  20 => "live",
  21 => "other"
}

count = 0
id = 1

file = File.open("sps.txt").each do |line|

  student = File.open("#{id}.txt", "w")
  txt = ""

  line.split("\t").each do |item|
    count += 1

    if count < 22
      txt << "#{rows[count]}: #{item}\n"
      print "#{rows[count]}: #{item}\n"
    end
  end

  puts
  count = 0
  id += 1

  student << txt
  student.close
  
end
