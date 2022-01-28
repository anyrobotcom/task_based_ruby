# frozen_string_literal: true

module Helper
  def load_payload
    dir = ARGV[0] || Dir.pwd
    file = File.read(File.join(dir, 'input/payload.json'))
    JSON.parse(file)
  end
end
