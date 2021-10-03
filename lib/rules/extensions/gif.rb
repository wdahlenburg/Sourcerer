#!/bin/ruby
# frozen_string_literal: true

class GIFExtension < Rule
  def self.initiate
    @desc = 'GIF Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.gif'
  end
end
