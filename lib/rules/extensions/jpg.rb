#!/bin/ruby
# frozen_string_literal: true

class JPGExtension < Rule
  def self.initiate
    @desc = 'JPG Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.jpg' or url.uri.path.downcase.end_with? '.jpeg'
  end
end
