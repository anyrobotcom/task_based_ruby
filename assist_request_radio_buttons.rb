#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'

gemfile do
  source 'https://rubygems.org'
  gem 'faraday', '1.1.0'
end

abort 'Usage: ./assist_request_input PORTAL_URL BOT_SECRET JOB_ID' unless ARGV.size == 3
portal_url, bot_secret, job_id = ARGV

response = Faraday.post("#{portal_url}/api/v1/jobs/#{job_id}/assist_requests") do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + bot_secret
  req.body = { genre: :radio_buttons, question: 'Which color?', choices: { 'RED' => :red, 'GREEN' => 'green', 'BLUE' => :blue } }.to_json
end ; response = JSON.parse response.body

abort "Failed to create Assist Request: #{response['error']}" unless '201 Created' == response['status']
assist_request_id = response['id']

assist_request_response = loop do
  response = Faraday.get("#{portal_url}/api/v1/assist_requests/#{assist_request_id}") do |req|
    req.headers['Authorization'] = 'Bearer ' + bot_secret
  end ; response = JSON.parse response.body

  break response['response'] if response['response']

  puts "Assist Request check is pending: #{response} -- please assist in the admin panel"
  sleep 1
end

puts "Assist Request got responded with: #{assist_request_response}"
