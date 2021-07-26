#!/bin/ruby
# frozen_string_literal: true

require 'pry'

class NonStandardPort < Rule
  def self.initiate
    @desc = 'Returns if the port is not 80 or 443'
  end

  def self.evaluate(url)
    url.uri.port != 80 && url.uri.port != 443
  end
end
