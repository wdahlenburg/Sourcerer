#!/bin/ruby
# frozen_string_literal: true

require 'yaml'
require 'optparse'

# Load the rules
Dir[File.join('./lib/', '**/*.rb')].sort.each do |f|
  require f
end

args = ARGV
args = %w[--help] if args.empty?

options = {}
option_parser = OptionParser.new do |opts|
  opts.banner = 'Usage: sourcerer.rb [--config=config.yaml] [--dirsearch|--urls] [--print-only] [--class=aggregator_urls] [--queue=aggregator_urls] --file=<input_file>'

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
  opts.on('--disable-recurse', 'Disable folder recursion') do |r|
    options[:disable_recurse] = r
  end
  opts.on('--file', '--file=FILE', 'Input file') do |f|
    options[:file] = f
  end
  opts.on('--config', '--config=CONFIG', 'Config file') do |c|
    options[:config] = c
  end
  opts.on('--print-only', 'Only print. Do not add to redis') do |_p|
    options[:print_only] = true
  end
end

option_parser.parse! args
options[:config] ||= 'config.yaml'

if options[:file].nil? || (options[:urls].nil? && options[:dirsearch].nil?)
  puts option_parser.parse! %w[--help]
  exit 1
end

config = YAML.load_file(options[:config])
worker = Worker.new(RedisConfig.new(config['redis']))
worker.get_rules(config)

config_options = {
  class: options[:class],
  queue: options[:queue],
  print_only: options[:print_only]
}
config_options[:class] ||= 'aggregator_urls'
config_options[:queue] ||= 'aggregator_urls'

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

if options[:disable_recurse]
  worker.run_rules(urls, config_options)
else
  worker.run_rules(urls, config_options, true)
end
