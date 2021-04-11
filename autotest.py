#!/usr/bin/env python

import subprocess
return_code = subprocess.call(['chromedriver', '--version'])
print("Output of call() : ", return_code)

# # Test output with

# print("Hello world!")

# # Test Chromedriver (install first)

# begin
#   `chromedriver --help`
#   puts "Chromedriver is present ✅"
# rescue Errno::ENOENT
#   abort "No chromedriver present, aborting 🛑"
# end

# # Input ARGV

# puts "ARGV (arguments): #{ARGV.inspect}"
# puts "ENV (environment): #{ENV.inspect}"

# # Response

# result = nil

# loop do
#   puts "Type failure or success script pass to finish script gracefully:"
#   result = gets.chomp
#   if ["failure", "success"].include?(result)
#     break
#   else
#     puts "Wrong answer, try again!"
#   end
# end

# # Exit code

# case result
# when "failure"
#   abort "Failed!"
# when "success"
#   puts "Gets done!"
# end