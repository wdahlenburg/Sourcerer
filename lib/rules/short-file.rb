#!/bin/ruby
# frozen_string_literal: true

class ShortFile < Rule
  def self.initiate
    @desc = 'Ensures the string length of the endpoint is less than 150 characters'
  end

  def self.evaluate(url)
    endpoint = url.uri.path.split('/')[-1]
    return true if endpoint.nil?
    return endpoint.length < 150
  end
end
