#!/bin/ruby
# frozen_string_literal: true

class PNGExtension < Rule
  def self.initiate
    @desc = 'PNG Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.png'
  end
end
