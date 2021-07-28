#!/bin/ruby
# frozen_string_literal: true

class CSSExtension < Rule
  def self.initiate
    @desc = 'CSS Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.css'
  end
end
