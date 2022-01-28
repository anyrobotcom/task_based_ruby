#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'

gemfile do
  source 'https://rubygems.org'
  gem 'faraday', '1.1.0'
end

payload = JSON.parse(File.read './payload.json')

60.times do
  response = Faraday.post(payload['live_logging_url']) do |req|
    req.headers['Content-Type'] = 'application/json'
    req.headers['Authorization'] = 'Bearer ' + payload['secret']
    req.body = { lines: ["What time?", "Current time is: #{Time.now}"] }.to_json
  end ; abort "Failed to create log line (status: #{response.status})" unless response.status == 201
  sleep 1
end

puts "All 60 log lines sent to the server"
