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

response = Faraday.post(payload['results_url']) do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + payload['secret']
  req.body = { genre: :failure, code: 1, attachments: [
    { genre: :text, name: 'list.txt', code: :important_stuff, body: 'ok' },
    { genre: :html, name: 'list.htm', code: :important_stuff, body: '<p>ok</p>' },
    { genre: :file, name: 'list.png', code: :important_stuff, body: 'data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUA
    AAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO
        9TXL0Y4OHwAAAABJRU5ErkJggg==' },
    { genre: :table, name: 'xls.csv', code: :important_stuff, body: 'a,b,c;1,2,3' },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 123, target: 1000 }.to_json },
  ] }.to_json
end

abort 'Failed to create Job Result' unless 201 == response.status
puts 'Successfully created Job Result on failure'
