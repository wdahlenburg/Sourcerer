#!/bin/ruby
# frozen_string_literal: true

class ICOExtension < Rule
  def self.initiate
    @desc = 'ICO Extension'
  end

  def self.evaluate(url)
    url.uri.path.end_with? '.ico'
  end
end
