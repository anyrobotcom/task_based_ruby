#!/usr/bin/env ruby

require 'json'

# Test output with

puts "Hello, I'm AnyRobot! 😀"

# Test Chromedriver (remember to install it first)

begin
  `chromedriver --help`
  puts "Chromedriver is present ✅"
rescue Errno::ENOENT
  abort "No chromedriver present, aborting 🛑"
end

# Load payload

file = File.read("./input/payload.json")
payload = JSON.parse(file)

# Print ARGV + ENV

puts "Payload: #{payload.inspect}"
puts "Arguments: #{ARGV.inspect}"
puts "Environment: #{ENV.inspect}"

# Response from user / stdin + failure or success

result = nil

loop do
  puts "Type failure or success script pass to finish script gracefully:"
  input_result = gets.chomp
  if input_result == "failure"
    abort "Failed!"
  elsif input_result == "success"
    puts "Gets done!"
  else
    puts "Wrong answer, try again..."
  end
end
