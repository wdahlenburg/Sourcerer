#!/bin/ruby
# frozen_string_literal: true

require 'yaml'
require 'optparse'

# Load the rules
Dir[File.join('./lib/', '**/*.rb')].sort.each do |f|
  require f
end

options = {}
option_parser = OptionParser.new do |opts|
  opts.banner = 'Usage: sourcerer.rb [--dirsearch|--hounds] <input_file>'

  opts.on('--dirsearch', 'Ingest Dirsearch input') do |_d|
    options[:dirsearch] = true
  end
  opts.on('--hounds', 'Ingest Hounds input') do |_h|
    options[:hounds] = true
  end
end.parse!

if options[:hounds].nil? && options[:dirsearch].nil?
  puts option_parser.help
  exit 1
end

config = YAML.load_file('config.yaml')
worker = Worker.new(config['redis-server'])
worker.get_rules(config)

urls = []

if options[:dirsearch]
  # Get sys.argv[1] as stdin file
  file = File.open(ARGV[0])
  file_data = file.readlines.map(&:chomp)
  file_data.each do |line|
    urls.concat Dirsearch.parse_input(line)
  end
elsif options[:hounds]
  file = File.open(ARGV[0])
  file_data = file.readlines.map(&:chomp)
  urls = file_data
end

worker.run_rules(urls, true)
