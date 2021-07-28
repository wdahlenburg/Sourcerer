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
  opts.banner = 'Usage: sourcerer.rb [--dirsearch|--urls] [--class=aggregator_urls] [--queue=aggregator_urls] --file=<input_file>'

  opts.on('--dirsearch', 'Ingest JSON Dirsearch input') do |_d|
    options[:dirsearch] = true
  end
  opts.on('--urls', 'Ingest urls input') do |_h|
    options[:urls] = true
  end
  opts.on('--class', '--class[=CLASS]', 'Sidekiq class') do |c|
    options[:class] = c
  end
  opts.on('--queue', '--queue[=QUEUE]', 'Redis Queue') do |q|
    options[:queue] = q
  end
  opts.on('--file', '--file=FILE', 'Input file') do |f|
    options[:file] = f
  end
end.parse! %w[--help]

if options[:file].nil? || (options[:urls].nil? && options[:dirsearch].nil?)
  puts option_parser.help
  exit 1
end

config = YAML.load_file('config.yaml')
worker = Worker.new(config['redis-server'])
worker.get_rules(config)

sidekiq_options = {
  class: options[:class],
  queue: options[:queue]
}
sidekiq_options[:class] ||= 'aggregator_urls'
sidekiq_options[:queue] ||= 'aggregator_urls'

urls = []

if options[:dirsearch]
  # Get sys.argv[1] as stdin file
  file = File.open(options[:file])
  file_data = file.readlines.map(&:chomp)
  file_data.each do |line|
    urls.concat Dirsearch.parse_input(line)
  end
elsif options[:urls]
  file = File.open(options[:file])
  file_data = file.readlines.map(&:chomp)
  urls = file_data
end

worker.run_rules(urls, sidekiq_options, true)
