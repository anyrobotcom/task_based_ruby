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

puts "---------- SCRIPT DETAILS"
puts "RUNNING FILE: #{__dir__ + "/" + __FILE__}"
if File.exist?("input/payload.json")
  puts "---------- PAYLOAD"
  puts `cat input/payload.json`
else
  puts "PAYLOAD: NONE"
end

run_command_with_live_logging("cd \"#{ENV['HOME']}/Code/runnertests/tasks\" && bundle exec ruby job_results_update_all_attachments.rb \"#{Dir.pwd}\"")

if $?.success?
  exit 0
else
  exit 1
end
