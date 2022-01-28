#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'
require_relative '../lib/helper'

include Helper

gemfile do
  source 'https://rubygems.org'
  gem 'faraday', '1.1.0'
end

payload = load_payload

response = Faraday.post(payload['assist_requests_url']) do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + payload['secret']
  req.body = { genre: :input, question: 'Is it assisted already?', required: true, confirm: 'confirm', short: true, expires_at: '2021-01-01 01:01:01' }.to_json
end ; response = JSON.parse response.body

abort "Failed to create Assist Request: #{response['error']}" unless '201 Created' == response['status']
assist_request_poll_url = response['url']

response = Faraday.get(assist_request_poll_url) do |req|
  req.headers['Authorization'] = 'Bearer ' + payload['secret']
end ; response = response.body

puts "Assist Request check is expired: #{response}"
