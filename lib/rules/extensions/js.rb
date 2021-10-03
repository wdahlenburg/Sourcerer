#!/bin/ruby
# frozen_string_literal: true

class JSExtension < Rule
  def self.initiate
    @desc = 'JS Extension'
  end

  def self.evaluate(url)
    url.uri.path.downcase.end_with? '.js'
  end
end
