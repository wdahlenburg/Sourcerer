#!/bin/ruby
# frozen_string_literal: true

class TTFExtension < Rule
  def self.initiate
    @desc = 'TTF Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.ttf'
  end
end
