#!/bin/ruby
# frozen_string_literal: true

class WOFFExtension < Rule
  def self.initiate
    @desc = 'WOFF Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.woff' or url.uri.path.end_with? '.woff2'
  end
end
