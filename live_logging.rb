#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'

gemfile do
  source 'https://rubygems.org'
  gem 'faraday', '1.1.0'
end

abort 'Usage: ./live_logging.rb PORTAL_URL BOT_SECRET JOB_ID' unless ARGV.size == 3
portal_url, bot_secret, job_id = ARGV

60.times do
  response = Faraday.post("#{portal_url}/api/v1/jobs/#{job_id}/output") do |req|
    req.headers['Content-Type'] = 'application/json'
    req.headers['Authorization'] = 'Bearer ' + bot_secret
    req.body = { lines: ["What time?", "Current time is: #{Time.now}"] }.to_json
  end ; abort "Failed to create log line (status: #{response.status})" unless response.status == 201
  sleep 1
end

puts "All 60 log lines sent to the server"
