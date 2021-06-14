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
  req.body = { genre: :input, question: 'Is it assisted already?', required: true, confirm: 'confirm', short: true, expires_at: '2021-01-01 01:01:01' }.to_json
end ; response = JSON.parse response.body

abort "Failed to create Assist Request: #{response['error']}" unless '201 Created' == response['status']
assist_request_id = response['id']

response = Faraday.get("#{portal_url}/api/v1/assist_requests/#{response['id']}") do |req|
  req.headers['Authorization'] = 'Bearer ' + bot_secret
end ; response = response.body

puts "Assist Request check is expired: #{response}"
