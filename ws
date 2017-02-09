#!/usr/bin/env ruby
#
#    Copyright (C)
#
#    This program is free software: You can do whatever you like - no limitation.
#
#    Comments, suggestions, questions to:flemming@familien-jahn.dk

if Gem::Specification::find_all_by_name('pry').any?
  require 'pry'      # For debugging
end

require 'optparse' # For command line parsing
require 'io/console'
require 'date'

worksheetFile = File.dirname($0) + "/worksheet.txt"
#
# Option parser
#
def checkOptions options
  OptionParser.new do |opts|
    opts.banner = "Usage: [Text] [option]"
    opts.version = 0.1

    opts.on("-d", "--description", "Prints a description of this script.") do
      puts "If you like me are working in Scrum team, and have to give a daily update, but sometime can't remember what you did yesterday,"
      puts "it is nice to have quick way to store the tasks you have done in a worksheet text file."
      puts "There are plenty of similar tools 'out there', but I found them all 'over-engineered, so I made this simply command line tool which"
      puts "doesn't have a lot of fancy features, but can simply store the tasks easily in a file from the command line. The worksheet text file is stored in the file directory containing this script."
      puts ""
      puts "Examples:"
      puts ""
      puts "Example: Add new task to your worksheet. E.g. that you fixed a bug"
      puts "ws I fixed bug number xxxx"
      puts ""
      puts "Example: Show the 10 lines of your work-sheet (just before go to daily scrum meeting :)"
      puts "ws"
      exit
    end

  end.order!
  cmd_line = "#{ARGV.join( ' ' )}"
  return cmd_line
end

#
# Insert text in begining of worksheet
#
def prePendText fileName, newTxt
  f = File.open(fileName, "r+")
  inLines = f.readlines
  f.close

  fileModDate = File.mtime(fileName)

  time = Time.new
  month = Date::MONTHNAMES[Date.today.month]
  dayName =  Date.today.strftime("%A")
  date = ["#{dayName} #{time.year}-#{month}-#{time.day}"]
  outLines = ["#{date[0]}: #{newTxt}\n"]
  # If it is a new day, then insert a seperator.
  if fileModDate.year != time.year || fileModDate.month != time.month || fileModDate.day != time.day
    outLines += ["***********************************************\n\n"]
  end

  outLines += inLines
  output = File.new(fileName, "w")
  outLines.each { |line| output.write line }
  output.close
end

#
# Print last 10 lines
#
def show fileName
  f = File.open(fileName, "r+")
  inLines = f.readlines
  f.close
  puts "\n***********************************************"
  inLines.each_with_index {|val, index|
    puts "#{val}"
    if index > 10
      exit
    end
  }

  exit
end


#
#  Script start
#
options = {}
workLine = checkOptions options

# Show last 10 inserts
if workLine == ""
  show worksheetFile
  exit
end

# Prepend new line
prePendText worksheetFile, workLine
show worksheetFile
