#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'
require 'faraday'
require_relative '../lib/helper'

include Helper

print_debug

puts 'getting payload'

payload = load_payload

puts 'creating response'

response = Faraday.post(payload['results_url']) do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + payload['secret']
  req.body = { genre: :failure, code: 1, attachments: [
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 2, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 3, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 5, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 3, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 7, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 6, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 3, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 6, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 8, target: 13, display: :gauge } },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 9, target: 13, display: :gauge } },
  ] }.to_json
end

puts 'response created'
puts 'response code == ' + response.status

abort 'Failed to create Job Result' unless 201 == response.status
puts 'Successfully created Job Result on failure'
