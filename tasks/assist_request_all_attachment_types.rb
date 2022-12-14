#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'
require 'faraday'
require_relative '../lib/helper'

include Helper

print_debug

payload = load_payload

response = Faraday.post(payload['assist_requests_url']) do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + payload['secret']
  req.body = { genre: :input, question: 'Is it assisted already?', required: true, confirm: 'confirm', short: true, attachments: [
    { genre: :text, name: 'list.txt', code: :important_stuff, body: 'ok' },
    { genre: :html, name: 'list.htm', code: :important_stuff, body: '<p>ok</p>' },
    { genre: :file, name: 'list.png', code: :important_stuff, body: 'data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUA
    AAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO
        9TXL0Y4OHwAAAABJRU5ErkJggg==' },
    { genre: :table, name: 'xls.csv', code: :important_stuff, body: 'a,b,c;1,2,3' },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 123, target: 1000 }.to_json },
  ] }.to_json
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
