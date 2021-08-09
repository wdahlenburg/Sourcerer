#!/bin/ruby
# frozen_string_literal: true

class ShortFolder < Rule
  def self.initiate
    @desc = 'Ensures the string length of all folders is less than 150 characters'
  end

  def self.evaluate(url)
    return false unless url.dir?

    folders = url.uri.path.split('/')
    folders.all? { |f| f.length < 150 }
  end
end
