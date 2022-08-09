require 'rubyXL'
require 'rubyXL/convenience_methods'
require 'watir'
require_relative '../lib/helper'

include Helper

$stdout.sync = true

print_debug

puts 'Testing Excel loading...'

workbook = RubyXL::Parser.parse('../assets/test_sheet.xlsx')

puts 'Excel loaded!'

val = workbook[0][0][0].value

puts val

puts 'Testing browser...'

chrome_options = {
  prefs: {
    download: {
      'prompt_for_download' => false,
      'directory_upgrade' => true,
    },
    'profile' => {
      'default_content_setting_values' => { 'automatic_downloads' => 1 },
    }
  },
}

browser = Watir::Browser.new(:chrome, headless: false, options: chrome_options)

browser.window.maximize

Selenium::WebDriver.logger.level = :error

browser.goto('https://www.google.com')

sleep 5

ok_button = browser.div(role: 'dialog').buttons[3]

ok_button.click

sleep 1

search_input = browser.input(name: 'q')

search_input.send_keys(val)

search_input.send_keys(:enter)

Watir::Wait.until(timeout: 30) { browser.div(id: 'top_nav').present? }

sleep 5

browser.close

puts 'Browser test completed!'
