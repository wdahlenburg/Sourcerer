#!/bin/ruby
# frozen_string_literal: true

require 'yaml'

# Load the rules
Dir[File.join('./lib/', '**/*.rb')].sort.each do |f|
  require f
end

config = YAML.load_file('config.yaml')
worker = Worker.new(config['redis-server'])
worker.get_rules(config)

# Get sys.argv[1] as stdin file
file = File.open(ARGV[0])
file_data = file.readlines.map(&:chomp)
urls = []
file_data.each do |line|
  urls.concat Dirsearch.parse_input(line)
end

worker.run_rules(urls, true)
