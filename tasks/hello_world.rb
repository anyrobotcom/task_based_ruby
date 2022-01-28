#!/usr/bin/env ruby

require 'json'

$stdout.sync = true

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

file = File.read("../assets/payload.json")
payload = JSON.parse(file)

# Print ARGV + ENV

puts "Payload: #{payload.inspect}"
puts "Arguments: #{ARGV.inspect}"
puts "Environment: #{ENV.inspect}"