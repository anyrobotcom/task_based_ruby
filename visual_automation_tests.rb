#!/usr/bin/env ruby
require 'json'
require 'mini_magick'
require 'faraday'
require 'ostruct'
require 'webdrivers'

# VisualAutomation examples
class VisualAutomation 
  @@localUrl = 'http://localhost:7777/api/v1'

  # Gets visual automation server status
  def self.status
    response = Faraday.get "#{@@localUrl}/status"
    puts "code #{response.status}"
    abort 'Failed checking status' unless response.status == 200
    puts response.body
    OpenStruct.new(JSON.parse(response.body))
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Gets and displays openapi.json
  def self.openapi
    response = Faraday.get "#{@@localUrl}/openapi.json"
    puts "code #{response.status}"
    abort 'Failed - coult not read openapi.json' unless response.status == 200
    puts 'Successfully found openapi.json'
    OpenStruct.new(JSON.parse(response.body))
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Enables debug overlay in Visual Automation server
  # Params:
  # - time: time in seconds to display debug overlay
  def self.enable_debug(time = 5)
    response = Faraday.put("#{@@localUrl}/debug", "{ 'enable' : true, 'time' : #{time} }")
    puts "code #{response.status}"
    abort 'Failed checking status' unless response.status == 200
    puts response.body
    OpenStruct.new(JSON.parse(response.body))
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Disables debug overlay in Visual Automation server
  def self.disable_debug
    response = Faraday.put("#{@@localUrl}/debug", "{ 'enable' : false, 'time' : 5 }")
    puts "code #{response.status}"
    abort 'Failed checking status' unless response.status == 200
    puts response.body
    OpenStruct.new(JSON.parse(response.body))
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Takes a screenshot from selected screen
  # Params:
  # - screen: screen index, starting from 0
  def self.screenshot(screen = 0)
    response = Faraday.get("#{@@localUrl}/screenshot", { 'screen' => screen })
    puts "code #{response.status}"
    abort 'Failed checking status' unless response.status == 200
    im = MiniMagick::Image.read(response.body)
    puts 'Screenshot format: PNG' if im.type == 'PNG'
    puts "Image width: #{im.width}"
    puts "Image height: #{im.height}"
    im
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Visual Find
  # Params:
  # - screen: screen index, starting from 0
  # - image_path: path to image file
  # - index: index of a result that will be returned, if -1 all results will be returned ordered by certainty
  def self.visual_find(screen, image_path, index = -1, threshold = 0.99)
    conn = Faraday.new(
      url: "#{@@localUrl}/visual/find",
      params: { 'screen' => screen, 'index' => index, 'threshold' => threshold }
      ) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    puts "image_path = #{image_path}"
    payload = { :file => Faraday::UploadIO.new(image_path, 'image/png') }

    puts payload

    response = conn.post('', payload) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "visual_find.response.status==#{response.status}"
    if response.status != 200
      false
    else
      json = JSON.parse response.body
      puts 'returning OpenStruct result'
      OpenStruct.new(json[0])
    end
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Click on imaged
  # Params:
  # - screen: screen index, starting from 0
  # - image_path: to image file
  # - index: index of a result that will be clicked
  # - button: 'left', 'right' or 'middle'
  # - offset_x: x click offset from the center of image
  # - offset_y: y click offset from the center of image
  # - double: true for doubleclick, false for single
  # - threshold: image search threshold (default = 0.99, default is used if threshold = 0)
  def self.click_image(screen, image_path, index, button = 'left', offset_x = 0, offset_y = 0, double = false, threshold = 0)
    conn = Faraday.new(
      url: "#{@@localUrl}/click/image",
      params: { 
        'screen' => screen,
        'index' => index,
        'button' => button,
        'offset_x' => offset_x,
        'offset_y' => offset_y,
        'double' => double,
        'threshold' => threshold
      }
      ) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    puts "image_path = #{image_path}"
    payload = { :file => Faraday::UploadIO.new(image_path, 'image/png') }

    # puts payload

    response = conn.post('', payload) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "visual_find.response.status==#{response.status}"
    if response.status != 200
      false
    else
      json = JSON.parse response.body
      puts 'returning OpenStruct result'
      OpenStruct.new(json[0])
    end
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Click on coordinates
  # Params:
  # - x: x coordinate
  # - y: y coordinate
  # - screen: screen index, starting from 0
  # - button: 'left', 'right' or 'middle'
  # - double: true for doubleclick, false for single
  def self.click_coordinates(x, y, screen = 0, button = 'left', double = false)
    puts "click_coordinates x=#{x} y=#{y} screen=#{screen} button=#{button} double=#{double}"

    conn = Faraday.new(
      url: "#{@@localUrl}/click/coordinates",
      params: { 'screen' => screen, 'button' => button, 'double' => double, 'x' => x, 'y' => y }
      ) do |f|
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    response = conn.post('', nil) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "code #{response.status}"
    abort 'Failed checking status' unless response.status == 201
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Hover on coordinates
  # Params:
  # - x: x coordinate
  # - y: y coordinate
  # - screen: screen index, starting from 0
  def self.hover(x, y, screen = 0)
    conn = Faraday.new(
      url: "#{@@localUrl}/hover",
      params: { 'screen' => screen, 'x' => x, 'y' => y }
      ) do |f|
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    response = conn.post('', nil) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "code #{response.status}"
    abort 'Failed checking status' unless response.status == 201
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end


  # Click on text
  # Params:
  # - lang: text language
  # - text: (string) text to find
  # - screen: screen index, starting from 0
  # - button: 'left', 'right' or 'middle'
  # - double: true for doubleclick, false for single
  # - index: search result index to use, default is 0 - first result
  # - offset_x: click x offset from the center of text
  # - offset_y: click y offset from the center of text
  # - roi_x: x coord of ROI rect
  # - roi_y: y coord of ROI rect
  # - roi_w: ROI width
  # - roi_h: ROI height
  # - black_text: default true, false for invert preprocessing - helps in some scenarios with light text on dark background
  # - do_not_preprocess: if true disables screen capture preprocessing before character recognition is triggered - use on special ocations if nothing helps
  def self.click_text(lang, text, screen = 0, button = 0, double = false, index = 0, 
    offset_x = 0, offset_y = 0, roi_x = -1, roi_y = -1, roi_w = -1, roi_h = -1, black_text = true, do_not_preprocess = false)
    conn = Faraday.new(
      url: "#{@@localUrl}/click/text",
      params: { 
        'lang' => lang,
        'text' => text,
        'screen' => screen,
        'button' => button,
        'double' => double,
        'index' => index,
        'offset_x' => offset_x,
        'offset_y' => offset_y,
        'roi_x' => roi_x,
        'roi_y' => roi_y,
        'roi_w' => roi_w,
        'roi_h' => roi_h,
        'black_text' => black_text,
        'do_not_preprocess' => do_not_preprocess
      }
      ) do |f|
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    response = conn.post('', nil) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "code #{response.status}"
    puts "response #{response.body}"
    abort 'Failed checking status' unless response.status == 201
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end


  # Perform drag and drop action
  # Params:
  # - screen: screen index, starting from 0
  # - start_x: drag start x coordinate
  # - start_y: drag start y coordinate
  # - end_x: drop end x coordinate
  # - end_y: drop end y coordinate
  # - button: 'left', 'right' or 'middle'
  # - speed: drag and drop animation speed
  def self.drag_and_drop(screen, start_x, start_y, end_x, end_y, button = 0, speed = 1)
    conn = Faraday.new(
      url: "#{@@localUrl}/drag_and_drop",
      params: { 
        'screen' => screen,
        'button' => button,
        'start_x' => start_x,
        'start_y' => start_y,
        'end_x' => end_x,
        'end_y' => end_y,
        'speed' => speed
      }
      ) do |f|
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    response = conn.post('', nil) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "code #{response.status}"
    puts "response #{response.body}"
    abort 'Failed checking status' unless response.status == 201
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Find text on screen
  # Params:
  # - language: text language
  # - text: (string) text to find
  # - screen: screen index, starting from 0
  # - index: search index to display, if -1 all results are displayed
  # - roi_x: x coord of ROI rect
  # - roi_y: y coord of ROI rect
  # - roi_w: ROI width
  # - roi_h: ROI height
  # - black_text: default true, false for invert preprocessing - helps in some scenarios with light text on dark background
  # - do_not_preprocess: if true disables screen capture preprocessing before character recognition is triggered - use on special ocations if nothing helps
  def self.ocr_find(language, text, screen = 0, index = -1, roi_x = -1, roi_y = -1, roi_w = -1, roi_h = -1, black_text = true, do_not_preprocess = false)
    conn = Faraday.new(
      url: "#{@@localUrl}/ocr/find",
      params: { 
        'language' => language,
        'text' => text,
        'screen' => screen,
        'index' => index,
        'roi_x' => roi_x,
        'roi_y' => roi_y,
        'roi_w' => roi_w,
        'roi_h' => roi_h,
        'black_text' => black_text,
        'do_not_preprocess' => do_not_preprocess
      }
      ) do |f|
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    response = conn.post('', nil) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "code #{response.status}"
    puts "response #{response.body}"
    abort 'Failed checking status' unless response.status == 201
    OpenStruct.new(JSON.parse(response.body))
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

  # Get text from screen
  # Params:
  # - language: text language
  # - screen: screen index, starting from 0
  # - roi_x: x coord of ROI rect
  # - roi_y: y coord of ROI rect
  # - roi_w: ROI width
  # - roi_h: ROI height
  # - black_text: default true, false for invert preprocessing - helps in some scenarios with light text on dark background
  # - do_not_preprocess: if true disables screen capture preprocessing before character recognition is triggered - use on special ocations if nothing helps
  def self.ocr_get(language, screen = 0, roi_x = -1, roi_y = -1, roi_w = -1, roi_h = -1, black_text = true, do_not_preprocess = false)
    puts "ocr_get roi_x=#{roi_x} roi_y=#{roi_y} roi_w=#{roi_w} roi_h=#{roi_h}"

    conn = Faraday.new(
      url: "#{@@localUrl}/ocr/get",
      params: { 
        'language' => language,
        'screen' => screen,
        'roi_x' => roi_x,
        'roi_y' => roi_y,
        'roi_w' => roi_w,
        'roi_h' => roi_h,
        'black_text' => black_text,
        'do_not_preprocess' => do_not_preprocess
      }
      ) do |f|
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    response = conn.post('', nil) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "code #{response.status}"
    abort 'Failed checking status' unless response.status == 200
    OpenStruct.new(JSON.parse(response.body))
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end


  # Simulate keyboard input
  # Params:
  # - keys: key sequence to type in special format, see docs
  def self.type(keys)
    conn = Faraday.new(
      url: "#{@@localUrl}/type",
      params: { 'keys' => keys }
      ) do |f|
      f.request :url_encoded
      f.adapter :net_http # This is what ended up making it work
    end

    response = conn.post('', nil) do |req|
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    puts "code #{response.status}"
    puts "response #{response.body}"
    abort 'Failed checking status' unless response.status == 201
  rescue StandardError => e
    abort "Failed, exception: #{e}"
  end

end

class Helpers

  def self.crop_random(image, width, height)
    raise TypeError, 'image must be MiniMagic::Image' unless image.is_a?(MiniMagick::Image)

    raise ArgumentError, 'size bigger than image' unless width < image.width && height < image.height

    x = rand(image.width - width)
    y = rand(image.height - height)

    cropped_image = MiniMagick::Image.open(image.path)

    cropped_image.crop "#{width}x#{height}+#{x}+#{y}"

    crop_result = OpenStruct.new
    crop_result.image = cropped_image
    crop_result.x = x
    crop_result.y = y
    crop_result.w = width
    crop_result.h = height

    crop_result
  end

end

# VisualAutomation example tests
class VisaulTests


  def self.visual_find_test(image, iterations, threshold, search_width, search_height, delay = 5)

    result_errors = Array.new

    (0..iterations).each do |counter|
      puts "Find cropped screenshot ##{counter}"
      cropped = Helpers.crop_random(image, search_width, search_height)
      searched_params = OpenStruct.new
      searched_params.x = cropped.x
      searched_params.y = image.height - cropped.y
      searched_params.w = cropped.w
      searched_params.h = cropped.h

      puts 'visual_find...'
      result = VisualAutomation.visual_find(0, cropped.image.path, 0)

      puts "iteration result: #{result} -> #{result.class}"

      if [true, false].include? result
        result_errors.push(false)
        puts 'Image not found'
      else
        max_error = [
          (result.x - searched_params.x).abs,
          (result.y - searched_params.y).abs,
          (result.w - searched_params.w).abs,
          (result.h - searched_params.h).abs
        ].max

        result_errors.push(max_error)

        puts "Searched image area: x=#{searched_params.x} y=#{searched_params.y} w=#{searched_params.w} h=#{searched_params.h}"
        puts "              Found: x=#{result.x} y=#{result.y} w=#{result.w} h=#{result.h}"
        puts "Max error: #{max_error}"
      end

      puts "Find iter #{counter} result: #{result}"
      sleep delay
    end

    puts '--- Visual Find test result ---'
    result_errors.each do |err|
      puts "Iteration result: #{err}"
    end
    puts '--- ---'
  end
end


begin

  puts 'Check server status'
  VisualAutomation.status

  puts 'Openapi.json'
  VisualAutomation.openapi

  puts 'CHROMEDRIVER TESTS'
  dpi_factor = VisualAutomation.status.screens[0]['dpi_factor']
  
  
  options = Selenium::WebDriver::Chrome::Options.new  
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.navigate.to "https://www.google.com"
  
  chrome_width = driver.manage.window.size.width
  chrome_height = driver.manage.window.size.height
  chrome_x = driver.manage.window.position.x
  chrome_y = VisualAutomation.status.screens[0]['height'] - driver.manage.window.position.y

  chrome_width = (chrome_width * dpi_factor).round
  chrome_height = (chrome_height * dpi_factor).round

  puts "#{chrome_width} x #{chrome_height} +#{chrome_x} +#{chrome_y}"

  puts "driver.class = #{driver.class}"

  VisualAutomation.enable_debug
  ocr_result = VisualAutomation.ocr_get('pol', 0, chrome_x, chrome_y, chrome_width, chrome_height)
  puts ocr_result.plain_text
  sleep 1

  VisualAutomation.type('[CONTROL][L]https[shift][;]//www.w3schools.com/[shift][h][shift][t][shift][M][shift][L]/tryit.asp[shift][?]filename=tryhtml5[shift][-]draganddrop[enter]')

  sleep 3
  puts 'Looking for "Accept all"'
  VisualAutomation.click_text('eng', 'Accept all', 0, 0, false, 0, 0, 0, chrome_x, chrome_y - (chrome_height/2).round, chrome_width, (chrome_height/3).round, false)
  puts 'Found "Accept all"'
  sleep 3
  
  w3img = MiniMagick::Image.open('logo.png')
  puts w3img.width
  
  w3img.resize "#{w3img.width * dpi_factor}x#{w3img.height * dpi_factor}"
  puts w3img.width

  find_result = VisualAutomation.visual_find(0, w3img.tempfile.path, 0)
  puts find_result

  start_x = (find_result.x + find_result.w / 2).round
  start_y = (find_result.y - find_result.h / 2).round

  end_y = start_y + (find_result.h * 1.4).round
  end_x = start_x

  sleep 2
  VisualAutomation.drag_and_drop(0, start_x, start_y, end_x, end_y)

  sleep 5

  VisualAutomation.type('[CONTROL][L]justjoin.it[enter]')
  sleep 3

  VisualAutomation.type('[win][up]')
  sleep 1

  # update chrome window rect after win+up
  chrome_width = driver.manage.window.size.width
  chrome_height = driver.manage.window.size.height
  chrome_x = driver.manage.window.position.x
  chrome_y = VisualAutomation.status.screens[0]['height'] - driver.manage.window.position.y

  chrome_width = (chrome_width * dpi_factor).round
  chrome_height = (chrome_height * dpi_factor).round

  # get rid of "night mode" popup on justjoit.it
  VisualAutomation.click_coordinates((chrome_width/2).round, VisualAutomation.status.screens[0]['height'] - (150 * dpi_factor).round)
  sleep 1

  ruby_image = MiniMagick::Image.open('ruby.png')
  ruby_image.resize "#{ruby_image.width / 2 * dpi_factor}x#{ruby_image.height / 2 * dpi_factor}"

  puts 'VisualFind ruby icon'
  puts VisualAutomation.click_image(0, ruby_image.tempfile.path, 0)
  sleep 10

  VisualAutomation.hover(chrome_x + chrome_width - 15, chrome_y - 15)
  
  sleep 4

  # close chrome
  VisualAutomation.click_coordinates(chrome_x + chrome_width - 15, chrome_y - 15)
  
  puts 'Chromedriver test done'
  driver.close

  return

  # ADDITIONAL TEST - uncomment if necessary

  puts 'Disabling debug layer'
  VisualAutomation.disable_debug

  VisualAutomation.enable_debug 1

  screenshot = Visual.screenshot

  search_width = 650
  search_height = 650

  VisaulTests.visual_find_test(screenshot, 10, 4, search_width, search_height)

  puts 'Disabling debug layer'
  VisualAutomation.disable_debug

  puts 'End of Visual Find tests.'



rescue StandardError => e
  abort "Failed, exception: #{e}"
end
