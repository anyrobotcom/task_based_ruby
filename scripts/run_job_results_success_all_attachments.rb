#!/usr/bin/env ruby

# frozen_string_literal: true

$stdout.sync = true
$stderr.sync = true
def run_command_with_live_logging(cmd)
  IO.popen("#{cmd} 2>&1") do |pipe|
    pipe.sync = true
    while (str = pipe.gets)
      puts str
    end
  end
end

# --- START OF DEBUG ---
class Platform
  def self.mac
    success = (/darwin/ =~ RUBY_PLATFORM) != nil
  rescue StandardError => e
    puts 'error checking for mac'
  end

  def self.win
    success = (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  rescue StandardError => e
    puts 'error checking for windows'
  end
end

if Platform.win
  puts "---------- SCRIPT DETAILS"
  puts "RUNNING FILE: #{__dir__ + "/" + __FILE__}"
  if File.exist?("input/payload.json")
    puts "---------- PAYLOAD"
    puts `type input\\payload.json`
  else
    puts "PAYLOAD: NONE"
  end
  puts "---------- GIT UPDATE"
  puts `cd %UserProfile%/Code/runnertests && git pull`
elsif Platform.mac
  puts "---------- SCRIPT DETAILS"
  puts "RUNNING FILE: #{__dir__ + "/" + __FILE__}"
  if File.exist?("input/payload.json")
    puts "---------- PAYLOAD"
    puts `cat input/payload.json`
  else
    puts "PAYLOAD: NONE"
  end
  puts "---------- GIT UPDATE"
  puts `cd ~/Code/runnertests && git pull`
end
# --- END OF DEBUG ---

run_command_with_live_logging("cd \"#{ENV['HOME']}/Code/runnertests/tasks\" && bundle exec ruby job_results_success_all_attachments.rb \"#{Dir.pwd}\"")

if $?.success?
  exit 0
else
  exit 1
end
