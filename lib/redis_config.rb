#!/bin/ruby
# frozen_string_literal: true

class RedisConfig
  attr_reader :host, :password

  def initialize(config)
   @host = config['host']
   @password = config['password'] if config['password']
  end


  def generateSidekiqConfig
    config = { :url => "redis://#{@host}/0"}
    if @password
      config[:password] = @password
    end
    config
  end
end
