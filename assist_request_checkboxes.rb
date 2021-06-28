#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'

gemfile do
  source 'https://rubygems.org'
  gem 'faraday', '1.1.0'
end

payload = JSON.parse(File.read './input/payload.json')

response = Faraday.post(payload['assist_requests_url']) do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + payload['secret']
  req.body = { genre: :checkboxes, question: 'Which color?', choices: { 'RED' => :red, 'GREEN' => 'green', 'BLUE' => :blue } }.to_json
end ; response = JSON.parse response.body

abort "Failed to create Assist Request: #{response['error']}" unless '201 Created' == response['status']
assist_request_poll_url = response['url']

assist_request_response = loop do
  response = Faraday.get(assist_request_poll_url) do |req|
    req.headers['Authorization'] = 'Bearer ' + payload['secret']
  end ; response = JSON.parse response.body

  break response['response'] if response['response']

  puts "Assist Request check is pending: #{response} -- please assist in the admin panel"
  sleep 1
end

puts "Assist Request got responded with: #{assist_request_response}"
