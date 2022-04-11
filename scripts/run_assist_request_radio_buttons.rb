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

run_command_with_live_logging("cd \"#{ENV['HOME']}/Code/runnertests/tasks\" && bundle exec ruby assist_request_radio_buttons.rb \"#{Dir.pwd}\"")

if $?.success?
  exit 0
else
  exit 1
end
