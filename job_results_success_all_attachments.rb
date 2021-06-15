#!/usr/bin/env ruby

require 'bundler/inline'
require 'json'

gemfile do
  source 'https://rubygems.org'
  gem 'faraday', '1.1.0'
end

abort 'Usage: ./job_results_success_all_attachments.rb PORTAL_URL BOT_SECRET JOB_ID' unless ARGV.size == 3
portal_url, bot_secret, job_id = ARGV


response = Faraday.post("#{portal_url}/api/v1/jobs/#{job_id}/results") do |req|
  req.headers['Content-Type'] = 'application/json'
  req.headers['Authorization'] = 'Bearer ' + bot_secret
  req.body = { genre: :success, result: { color: :green }, attachments: [
    { genre: :text, name: 'list.txt', code: :important_stuff, body: 'ok' },
    { genre: :html, name: 'list.htm', code: :important_stuff, body: '<p>ok</p>' },
    { genre: :file, name: 'list.png', code: :important_stuff, body: 'data:image/png;base64,...' },
    { genre: :table, name: 'xls.csv', code: :important_stuff, body: 'a,b,c;1,2,3' },
    { genre: :kpi, name: 'stats.kpi', code: :important_stuff, body: { genre: :integer, value: 123 } },
  ] }.to_json
end

abort 'Failed to create Job Result' unless 201 == response.status
puts 'Successfully created Job Result on success'
