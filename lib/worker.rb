#!/bin/ruby
# frozen_string_literal: true

require 'sidekiq'
include Sidekiq::Worker

class Worker
  def initialize(redisConfig)
    Sidekiq.configure_server do |config|
      config.redis = redisConfig.generateSidekiqConfig
    end

    Sidekiq.configure_client do |config|
      config.redis = redisConfig.generateSidekiqConfig
    end
  end

  def get_rules(config)
    rules_set = []

    config['matchers']['rules'].each do |m|
      rule_set = []
      m['rule'].each do |rule|
        clazz = Kernel.const_get(rule)
        rule_set << clazz
      end
      condition = m['condition'] || 'or'
      rules_set << RulesSet.new(rule_set, condition)
    end

    if config['matchers']['condition']
      @rules = Rules.new(rules_set, config['matchers']['condition'])
    else
      @rules = Rules.new(rules_set)
    end
  end

  def run_rules(urls, sidekiq_options, recurse = false)
    urls.each do |url|
      STDERR.puts "Running #{url}"
      begin
        # Turn each url into Url object
        u = Url.new(url)
        run_rules(u.get_sub_folder_urls, sidekiq_options, false) if recurse == true

        if @rules.evaluate(u)
          if sidekiq_options[:print_only]
            puts url
          else
            Sidekiq::Client.push('class' => sidekiq_options[:class], 'args' => [url], 'queue' => sidekiq_options[:queue])
          end
        end
      rescue URI::InvalidURIError
        STDERR.puts "Unable to parse #{url}"
      end
    end
  end
end
