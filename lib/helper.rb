# frozen_string_literal: true

module Helper
  def load_payload
    dir = ARGV[0] || Dir.pwd
    file = File.read(File.join(dir, 'input/payload.json'))
    JSON.parse(file)
  end

  def print_debug
    puts "---------- RUBY DETAILS"
    puts "RUBY: " + `which ruby`
    puts "GEM: " + `which gem`
    puts "BUNDLE: " + `which bundle`
    puts "RAKE: " + `which rake`
    puts "VERSION: " + `ruby --version`
    puts "RUNNING FILE: #{__dir__ + "/" + __FILE__}"
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