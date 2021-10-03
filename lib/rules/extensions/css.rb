#!/bin/ruby
# frozen_string_literal: true

class CSSExtension < Rule
  def self.initiate
    @desc = 'CSS Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.css'
  end
end
