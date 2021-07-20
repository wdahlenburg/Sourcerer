#!/bin/ruby
# frozen_string_literal: true

require 'sidekiq'
include Sidekiq::Worker

class Worker
  def initialize(server)
    Sidekiq.configure_server do |config|
      config.redis = { url: "redis://#{server}/0" }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: "redis://#{server}/0" }
    end
  end

  def get_rules(config)
    @rules = []

    config['rules'].each do |rule|
      clazz = Kernel.const_get(rule)
      @rules << clazz
    end

    @rules
  end

  def run_rules(urls)
    urls.each do |url|
      puts "Running #{url}"
      begin
        # Turn each url into Url object
        u = Url.new(url)

        i = 0
        while i < @rules.length
          if @rules[i].evaluate(u)
            Sidekiq::Client.push('class' => 'aggregator_urls', 'args' => [url], 'queue' => 'aggregator_urls')
            break
          end
          i += 1
        end
      rescue URI::InvalidURIError
        puts "Unable to parse #{url}"
      end
    end
  end
end
