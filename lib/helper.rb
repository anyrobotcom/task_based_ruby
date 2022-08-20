# frozen_string_literal: true

module Helper

  class Platform
    def self.mac
      success = (/darwin/ =~ RUBY_PLATFORM) != nil
    rescue StandardError => e
      puts 'error checking for mac'
    end
  
    def self.win
      success = (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    rescue StandardError => e
      puts 'error checking for windows'
    end
  end

  def load_payload
    dir = ARGV[0] || Dir.pwd
    file = File.read(File.join(dir, 'input/payload.json'))
    JSON.parse(file)
  end

  def print_debug
    if Platform.win
      puts 'Platform WIN'
      puts "RUBY: " + `where ruby`
      puts "GEM: " + `where gem`
      puts "BUNDLE: " + `where bundle`
      puts "RAKE: " + `where rake`
      puts "VERSION: " + `ruby --version`
      puts "RUNNING FILE: #{__dir__ + "/" + __FILE__}"
      # puts "---------- RBENV BASICS"
      # puts "Global: " + `rbenv global` 
      # puts "Local: " + `rbenv local`
      # puts "From .ruby-version file: " + `cat ../.ruby-version`
      # puts "---------- RBENV DOCTOR OUTPUT"
      # puts `curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash`
      puts "---------- OTHER"
      puts "Chromedriver path: " + `which chromedriver`
      puts "Chromedriver version: " + `chromedriver --version`
      puts "---------- ENV DETAILS"
      ENV.each do |env|
        puts "#{env[0]}: #{env[1]}"
      end
      puts "---------- AUTOMATION BELOW"
    elsif Platform.mac
      puts 'Platform MAC'
      puts "---------- RUBY DETAILS"
      puts "RUBY: " + `which ruby`
      puts "GEM: " + `which gem`
      puts "BUNDLE: " + `which bundle`
      puts "RAKE: " + `which rake`
      puts "VERSION: " + `ruby --version`
      puts "RUNNING FILE: #{__dir__ + "/" + __FILE__}"
      puts "---------- RBENV BASICS"
      puts "Global: " + `rbenv global` 
      puts "Local: " + `rbenv local`
      puts "From .ruby-version file: " + `cat ../.ruby-version`
      puts "---------- RBENV DOCTOR OUTPUT"
      puts `curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash`
      puts "---------- OTHER"
      puts "Chromedriver path: " + `which chromedriver`
      puts "Chromedriver version: " + `chromedriver --version`
      puts "---------- ENV DETAILS"
      ENV.each do |env|
        puts "#{env[0]}: #{env[1]}"
      end
      puts "---------- AUTOMATION BELOW"
    end

    
  end
end