#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'

gemfile do
  source 'https://rubygems.org'
  gem 'faraday', '1.1.0'
end

abort 'Usage: ./assist_request_input PORTAL_URL BOT_SECRET JOB_ID' unless ARGV.size == 3
portal_url, bot_secret, job_id = ARGV


response = Faraday.post("#{portal_url}/api/v1/jobs/#{job_id}/results") do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + bot_secret
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

abort 'Failed to create Job Result' unless 201 == response.status
puts 'Successfully created Job Result on failure'
