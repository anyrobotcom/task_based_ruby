#!/usr/bin/env ruby

# frozen_string_literal: true

$stdout.sync = true
def run_command_with_live_logging(cmd)
  IO.popen("#{cmd} 2>&1") do |pipe|
    pipe.sync = true
    while (str = pipe.gets)
      puts str
    end
  end
end

# --- START OF DEBUG ---
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
# --- END OF DEBUG ---

run_command_with_live_logging("cd \"#{ENV['HOME']}/Code/runnertests/tasks\" && bundle exec ruby assist_request_checkboxes.rb \"#{Dir.pwd}\"")

if $?.success?
  exit 0
else
  exit 1
end
